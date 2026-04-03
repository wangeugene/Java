//
//  TeslaTrackClipExporter.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/3/26.
//

import Foundation
import AVFoundation
import CoreMedia
import CoreImage
import CoreGraphics
import AppKit

enum TeslaTrackClipExportError: LocalizedError {
    case invalidDuration
    case exportSessionCreationFailed
    case unsupportedOutputFileType(String)
    case exportFailed(String)
    case exportCanceled
    case invalidOverlayTimestamp(String)
    case missingVideoTrack

    var errorDescription: String? {
        switch self {
        case .invalidDuration:
            return "The selected export duration is invalid."
        case .exportSessionCreationFailed:
            return "Failed to create the MP4 export session."
        case .unsupportedOutputFileType(let type):
            return "The requested output file type is not supported by this export session: \(type)"
        case .exportFailed(let message):
            return "Failed to export the MP4 clip: \(message)"
        case .exportCanceled:
            return "The MP4 export was canceled."
        case .invalidOverlayTimestamp(let value):
            return "Failed to parse the preview timestamp for MP4 export: \(value)"
        case .missingVideoTrack:
            return "The composed track does not contain a video track."
        }
    }
}

enum TeslaTrackClipExporter {
    static func exportClipAroundCurrentTime(
        from track: TeslaComposedTrack,
        currentTime: CMTime,
        duration: TimeInterval = 10,
        overlayCurrentTimestampText: String,
        outputURL: URL
    ) async throws {
        guard duration > 0 else {
            throw TeslaTrackClipExportError.invalidDuration
        }

        let halfDuration = CMTime(seconds: duration / 2.0, preferredTimescale: 600)
        let zero = CMTime.zero
        let totalDuration = track.totalDuration

        let tentativeStart = currentTime - halfDuration
        let tentativeEnd = currentTime + halfDuration

        let start = CMTimeMaximum(zero, tentativeStart)
        let end = CMTimeMinimum(totalDuration, tentativeEnd)
        let exportRange = CMTimeRange(start: start, end: end)

        guard exportRange.duration > .zero else {
            throw TeslaTrackClipExportError.invalidDuration
        }

        if FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.removeItem(at: outputURL)
        }

        guard let exportSession = AVAssetExportSession(
            asset: track.composition,
            presetName: AVAssetExportPresetHighestQuality
        ) else {
            throw TeslaTrackClipExportError.exportSessionCreationFailed
        }

        exportSession.outputURL = outputURL
        let requestedFileType: AVFileType = {
            switch outputURL.pathExtension.lowercased() {
            case "mp4":
                return .mp4
            case "mov":
                return .mov
            case "m4v":
                return .m4v
            default:
                return .mp4
            }
        }()

        guard exportSession.supportedFileTypes.contains(requestedFileType) else {
            throw TeslaTrackClipExportError.unsupportedOutputFileType(requestedFileType.rawValue)
        }

        exportSession.outputFileType = requestedFileType
        exportSession.timeRange = exportRange
        exportSession.shouldOptimizeForNetworkUse = true

        let videoComposition = try await makeTimestampedVideoComposition(
            for: track.composition,
            currentPlaybackTime: currentTime,
            overlayCurrentTimestampText: overlayCurrentTimestampText
        )
        exportSession.videoComposition = videoComposition

        print("Export currentTime:", currentTime.seconds)
        print("Export totalDuration:", track.totalDuration.seconds)
        print("Export range start:", exportRange.start.seconds)
        print("Export range duration:", exportRange.duration.seconds)
        print("Export outputURL:", outputURL.path)
        print("Requested file type:", requestedFileType)
        print("Supported file types:", exportSession.supportedFileTypes)

        do {
            try await exportSession.export()
        } catch {
            print("Export threw error:", error.localizedDescription)
            print("Final export session status:", exportSession.status.rawValue)
            print("Final export session error:", exportSession.error?.localizedDescription ?? "nil")
            throw error
        }

        print("Final export session status:", exportSession.status.rawValue)
        print("Final export session error:", exportSession.error?.localizedDescription ?? "nil")

        switch exportSession.status {
        case .completed:
            return
        case .failed:
            let message = exportSession.error?.localizedDescription ?? "Unknown export error"
            throw TeslaTrackClipExportError.exportFailed(message)
        case .cancelled:
            throw TeslaTrackClipExportError.exportCanceled
        default:
            let message = exportSession.error?.localizedDescription ?? "Unexpected export state"
            throw TeslaTrackClipExportError.exportFailed(message)
        }
    }
}

private extension TeslaTrackClipExporter {
    static func makeTimestampedVideoComposition(
        for asset: AVMutableComposition,
        currentPlaybackTime: CMTime,
        overlayCurrentTimestampText: String
    ) async throws -> AVVideoComposition {
        let videoTracks = try await asset.loadTracks(withMediaType: .video)
        guard let videoTrack = videoTracks.first else {
            throw TeslaTrackClipExportError.missingVideoTrack
        }

        let naturalSize = try await videoTrack.load(.naturalSize)
        let preferredTransform = try await videoTrack.load(.preferredTransform)
        let transformedSize = naturalSize.applying(preferredTransform)
        let renderSize = CGSize(width: abs(transformedSize.width), height: abs(transformedSize.height))

        let currentOverlayDate = try parseOverlayTimestamp(overlayCurrentTimestampText)
        let ciContext = CIContext()
        var overlayCache: [Int: CIImage] = [:]

        let videoComposition = AVVideoComposition(asset: asset) { request in
            let sourceImage = request.sourceImage.clampedToExtent()
            let currentFrameDate = currentOverlayDate.addingTimeInterval(request.compositionTime.seconds - currentPlaybackTime.seconds)
            let wholeSecond = Int(floor(currentFrameDate.timeIntervalSince1970))

            let overlayCIImage: CIImage
            if let cached = overlayCache[wholeSecond] {
                overlayCIImage = cached
            } else {
                let formatted = overlayFormatter.string(from: currentFrameDate)
                let created = makeTimestampOverlayCIImage(
                    text: formatted,
                    renderSize: renderSize,
                    ciContext: ciContext
                )
                overlayCache[wholeSecond] = created
                overlayCIImage = created
            }

            let composited = overlayCIImage.composited(over: sourceImage)
                .cropped(to: CGRect(origin: .zero, size: renderSize))

            request.finish(with: composited, context: nil)
        }

        return videoComposition
    }

    static func parseOverlayTimestamp(_ text: String) throws -> Date {
        if let date = overlayFormatter.date(from: text) {
            return date
        }
        throw TeslaTrackClipExportError.invalidOverlayTimestamp(text)
    }

    static func makeTimestampOverlayCIImage(
        text: String,
        renderSize: CGSize,
        ciContext: CIContext
    ) -> CIImage {
        let width = Int(max(renderSize.width, 1))
        let height = Int(max(renderSize.height, 1))
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return CIImage(color: .clear).cropped(to: CGRect(origin: .zero, size: renderSize))
        }

        let nsContext = NSGraphicsContext(cgContext: context, flipped: false)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = nsContext

        let fontSize = max(18, min(renderSize.width * 0.025, 42))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .semibold),
            .foregroundColor: NSColor.white,
            .paragraphStyle: paragraphStyle
        ]

        let nsText = NSString(string: text)
        let textSize = nsText.size(withAttributes: attributes)
        let paddingX: CGFloat = 14
        let paddingY: CGFloat = 8
        let bubbleRect = CGRect(
            x: 20,
            y: renderSize.height - textSize.height - paddingY * 2 - 20,
            width: textSize.width + paddingX * 2,
            height: textSize.height + paddingY * 2
        )

        let bubblePath = NSBezierPath(roundedRect: bubbleRect, xRadius: 12, yRadius: 12)
        NSColor.black.withAlphaComponent(0.72).setFill()
        bubblePath.fill()

        let textRect = CGRect(
            x: bubbleRect.minX + paddingX,
            y: bubbleRect.minY + paddingY,
            width: textSize.width,
            height: textSize.height
        )
        nsText.draw(in: textRect, withAttributes: attributes)

        NSGraphicsContext.restoreGraphicsState()

        guard let cgImage = context.makeImage() else {
            return CIImage(color: .clear).cropped(to: CGRect(origin: .zero, size: renderSize))
        }

        return CIImage(cgImage: cgImage)
    }

    static let overlayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

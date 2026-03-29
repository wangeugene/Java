//
//  TimestampBurner.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/22/26.
//


import AVFoundation
import AppKit

enum TimestampBurner {
    static func exportVideoWithTimestamp(from sourceURL: URL) async throws -> URL {
        let asset = AVURLAsset(url: sourceURL)
        let json = getEventJSONContentFrom(url: sourceURL)
        if let data = json {
            if let object = try? JSONSerialization.jsonObject(with: data),
               let pretty = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
               let text = String(data: pretty, encoding: .utf8) {
                print("event.json (pretty):\n\(text)")
            } else {
                print("event.json bytes: \(data.count) (could not pretty print)")
            }
        } else {
            print("event.json: not found")
        }
        let composition = AVMutableComposition()

        guard
            let videoTrack = try await asset.loadTracks(withMediaType: .video).first,
            let compositionVideoTrack = composition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: kCMPersistentTrackID_Invalid
            )
        else {
            throw ExportError.videoTrackNotFound
        }

        let assetDuration = try await asset.load(.duration)
        try compositionVideoTrack.insertTimeRange(
            CMTimeRange(start: .zero, duration: assetDuration),
            of: videoTrack,
            at: .zero
        )
        compositionVideoTrack.preferredTransform = try await videoTrack.load(.preferredTransform)

        if let audioTrack = try await asset.loadTracks(withMediaType: .audio).first,
           let compositionAudioTrack = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid
           ) {
            try compositionAudioTrack.insertTimeRange(
                CMTimeRange(start: .zero, duration: assetDuration),
                of: audioTrack,
                at: .zero
            )
        }

        let videoSize = try await renderedVideoSize(for: videoTrack)
        let startDate = parseStartDate(from: sourceURL)
        
        let videoComposition = try await makeVideoComposition(
            for: composition,
            renderSize: videoSize,
            startDate: startDate
        )

        let outputURL = makeOutputURL(for: sourceURL)
        try? FileManager.default.removeItem(at: outputURL)

        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            throw ExportError.cannotCreateExportSession
        }

        exportSession.videoComposition = videoComposition
        exportSession.shouldOptimizeForNetworkUse = false

        try await export(using: exportSession, to: outputURL)
        return outputURL
    }
    
    private static func getEventJSONContentFrom(url: URL) -> Data? {
        // Locate event.json next to the passed-in .mp4 file
        let folderURL = url.deletingLastPathComponent()
        let jsonURL = folderURL.appendingPathComponent("event.json")
        do {
            return try Data(contentsOf: jsonURL)
        } catch {
            print("Failed to read event.json at \(jsonURL.path): \(error)")
            return nil
        }
    }
    
    private static func decodeEventJSON<T: Decodable>(_ type: T.Type, from url: URL) -> T? {
        guard let data = getEventJSONContentFrom(url: url) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Failed to decode event.json: \(error)")
            return nil
        }
    }

    private static func renderedVideoSize(for track: AVAssetTrack) async throws -> CGSize {
        let naturalSize = try await track.load(.naturalSize)
        let preferredTransform = try await track.load(.preferredTransform)
        let transformedRect = CGRect(origin: .zero, size: naturalSize).applying(preferredTransform)
        return CGSize(width: abs(transformedRect.width), height: abs(transformedRect.height))
    }

    private static func formatElapsed(seconds: Double) -> String {
        let total = Int(seconds.rounded(.towardZero))
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 {
            return String(format: "%02d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%02d:%02d", m, s)
        }
    }
    
    private static func makeVideoComposition(
        for asset: AVAsset,
        renderSize: CGSize,
        startDate: Date?
    ) async throws -> AVVideoComposition {
        return try await withCheckedThrowingContinuation { continuation in
            AVVideoComposition.videoComposition(
                with: asset,
                applyingCIFiltersWithHandler: { request in
                    let sourceImage = request.sourceImage.clampedToExtent()
                    let elapsed = CMTimeGetSeconds(request.compositionTime)
                    let text: String

                    if let startDate {
                        // Absolute time ticking
                        let currentDate = startDate.addingTimeInterval(elapsed)
                        let outputFormatter = DateFormatter()
                        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
                        outputFormatter.timeZone = .current
                        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        text = outputFormatter.string(from: currentDate)
                    } else {
                        // Fallback: show elapsed time ticking
                        text = formatElapsed(seconds: elapsed)
                    }

                    let attributedString = NSAttributedString(
                        string: text,
                        attributes: [
                            .font: NSFont.monospacedDigitSystemFont(ofSize: 22, weight: .medium),
                            .foregroundColor: NSColor.white
                        ]
                    )
                    let textImage = makeTextImage(from: attributedString)
                    let positionedText = textImage.transformed(
                        by: CGAffineTransform(
                            translationX: 36,
                            y: max(24, renderSize.height - textImage.extent.height - 33)
                        )
                    )

                    let compositedImage = positionedText
                        .composited(over: sourceImage)
                        .cropped(to: request.sourceImage.extent)

                    request.finish(with: compositedImage, context: nil)
                },
                completionHandler: { videoComposition, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let videoComposition {
                        continuation.resume(returning: videoComposition)
                    } else {
                        continuation.resume(throwing: ExportError.exportFailed)
                    }
                }
            )
        }
    }

    private static func makeTextImage(from attributedString: NSAttributedString) -> CIImage {
        let size = attributedString.size()
        let padding: CGFloat = 12
        let imageSize = CGSize(
            width: ceil(size.width + padding * 2),
            height: ceil(size.height + padding * 2)
        )

        let image = NSImage(size: imageSize)
        image.lockFocus()

        let backgroundRect = CGRect(origin: .zero, size: imageSize)
        let backgroundPath = NSBezierPath(roundedRect: backgroundRect, xRadius: 10, yRadius: 10)
        NSColor.black.withAlphaComponent(0.55).setFill()
        backgroundPath.fill()

        attributedString.draw(at: CGPoint(x: padding, y: padding))
        image.unlockFocus()

        guard
            let tiffData = image.tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiffData),
            let cgImage = bitmap.cgImage
        else {
            return CIImage.empty()
        }

        return CIImage(cgImage: cgImage)
    }

    private static func parseStartDate(from sourceURL: URL) -> Date? {
        let baseName = sourceURL.deletingPathExtension().lastPathComponent
        if let range = baseName.range(of: #"^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}"#, options: .regularExpression) {
            let timestampPrefix = String(baseName[range])

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = .current
            formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            return formatter.date(from: timestampPrefix)
        }
        return nil
    }
    
    private static func makeOutputURL(for sourceURL: URL) -> URL {
        let documentsURL = FileManager.default.homeDirectoryForCurrentUser
              .appendingPathComponent("Documents", isDirectory: true)
        print("Documents URL: \(documentsURL.path)")
        let baseName = sourceURL.deletingPathExtension().lastPathComponent
        return documentsURL.appendingPathComponent("\(baseName)-timestamped.mp4")
    }

    
    private static func export(using session: AVAssetExportSession, to outputURL: URL) async throws {
        try await session.export(to: outputURL, as: .mp4)
    }

    enum ExportError: LocalizedError {
        case videoTrackNotFound
        case cannotCreateExportSession
        case exportFailed
        case exportCancelled

        var errorDescription: String? {
            switch self {
            case .videoTrackNotFound:
                return "No video track was found in the selected file."
            case .cannotCreateExportSession:
                return "Unable to create the export session."
            case .exportFailed:
                return "The export did not complete successfully."
            case .exportCancelled:
                return "The export was cancelled."
            }
        }
    }
}


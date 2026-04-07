//
//  TeslaTrackFrameExporter.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/3/26.
//

import Foundation
import AVFoundation
import CoreMedia
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
import AppKit

enum TeslaTrackFrameExporter {
    static func exportJPEGSnapshot(
        from composedTrack: TeslaComposedTrack,
        at time: CMTime,
        overlayTimestampText: String,
        metadata: TeslaEventMetadata?,
        to outputURL: URL,
        jpegQuality: CGFloat = 0.98
    ) async throws {
        let imageGenerator = AVAssetImageGenerator(asset: composedTrack.composition)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
        let cgImage = try await generateCGImage(
            using: imageGenerator,
            at: time
        )
        let overlayedImage = try drawTimestampOverlay(
            on: cgImage,
            timestampText: overlayTimestampText
        )

        guard let destination = CGImageDestinationCreateWithURL(
            outputURL as CFURL,
            UTType.jpeg.identifier as CFString,
            1,
            nil
        ) else {
            throw SnapshotExportError.destinationCreationFailed(outputURL)
        }

        var properties: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: jpegQuality
        ]

        if let metadata {
            properties.merge(makeMetadataDictionary(from: metadata)) { _, new in new }
        }

        CGImageDestinationAddImage(destination, overlayedImage, properties as CFDictionary)

        guard CGImageDestinationFinalize(destination) else {
            throw SnapshotExportError.destinationFinalizeFailed(outputURL)
        }
    }
}

private extension TeslaTrackFrameExporter {
    static func generateCGImage(
        using generator: AVAssetImageGenerator,
        at time: CMTime
    ) async throws -> CGImage {
        try await withCheckedThrowingContinuation { continuation in
            generator.generateCGImageAsynchronously(for: time) { cgImage, _, error in
                if let cgImage {
                    continuation.resume(returning: cgImage)
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: SnapshotExportError.outputImageCreationFailed)
                }
            }
        }
    }

    static func drawTimestampOverlay(
        on cgImage: CGImage,
        timestampText: String
    ) throws -> CGImage {
        let width = cgImage.width
        let height = cgImage.height
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
            throw SnapshotExportError.contextCreationFailed
        }

        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)

        let nsContext = NSGraphicsContext(cgContext: context, flipped: false)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = nsContext

        let fontSize = max(18, min(CGFloat(width) * 0.025, 42))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .semibold),
            .foregroundColor: NSColor.white,
            .paragraphStyle: paragraphStyle
        ]

        let text = NSString(string: timestampText)
        let textSize = text.size(withAttributes: attributes)
        let paddingX: CGFloat = 14
        let paddingY: CGFloat = 8
        let bubbleRect = CGRect(
            x: 20,
            y: CGFloat(height) - textSize.height - paddingY * 2 - 20,
            width: textSize.width + paddingX * 2,
            height: textSize.height + paddingY * 2
        )

        let bubblePath = NSBezierPath(roundedRect: bubbleRect, xRadius: 12, yRadius: 12)
        NSColor.black.withAlphaComponent(0).setFill()
        bubblePath.fill()

        let textRect = CGRect(
            x: bubbleRect.minX + paddingX,
            y: bubbleRect.minY + paddingY,
            width: textSize.width,
            height: textSize.height
        )
        text.draw(in: textRect, withAttributes: attributes)

        NSGraphicsContext.restoreGraphicsState()

        guard let outputImage = context.makeImage() else {
            throw SnapshotExportError.outputImageCreationFailed
        }

        return outputImage
    }

    static func makeMetadataDictionary(from metadata: TeslaEventMetadata) -> [CFString: Any] {
        var result: [CFString: Any] = [:]

        var exif: [CFString: Any] = [:]
        exif[kCGImagePropertyExifUserComment] = "reason=\(metadata.reason); camera=\(metadata.camera)"
        exif[kCGImagePropertyExifDateTimeOriginal] = metadata.timestamp.replacingOccurrences(of: "T", with: " ")
        result[kCGImagePropertyExifDictionary] = exif

        if let latitude = Double(metadata.estLat),
           let longitude = Double(metadata.estLon) {
            var gps: [CFString: Any] = [:]
            gps[kCGImagePropertyGPSLatitude] = abs(latitude)
            gps[kCGImagePropertyGPSLatitudeRef] = latitude >= 0 ? "N" : "S"
            gps[kCGImagePropertyGPSLongitude] = abs(longitude)
            gps[kCGImagePropertyGPSLongitudeRef] = longitude >= 0 ? "E" : "W"
            result[kCGImagePropertyGPSDictionary] = gps
        }

        var iptc: [CFString: Any] = [:]
        iptc[kCGImagePropertyIPTCCity] = metadata.city
        iptc[kCGImagePropertyIPTCSubLocation] = metadata.street
        result[kCGImagePropertyIPTCDictionary] = iptc

        var tiff: [CFString: Any] = [:]
        tiff[kCGImagePropertyTIFFImageDescription] = "location=\(metadata.city) \(metadata.street)"
        result[kCGImagePropertyTIFFDictionary] = tiff

        return result
    }
}

enum SnapshotExportError: LocalizedError {
    case contextCreationFailed
    case outputImageCreationFailed
    case destinationCreationFailed(URL)
    case destinationFinalizeFailed(URL)

    var errorDescription: String? {
        switch self {
        case .contextCreationFailed:
            return "Failed to create the graphics context for snapshot export."
        case .outputImageCreationFailed:
            return "Failed to create the final image for snapshot export."
        case .destinationCreationFailed(let url):
            return "Failed to create the JPEG destination at \(url.path)."
        case .destinationFinalizeFailed(let url):
            return "Failed to finalize the JPEG file at \(url.path)."
        }
    }
}

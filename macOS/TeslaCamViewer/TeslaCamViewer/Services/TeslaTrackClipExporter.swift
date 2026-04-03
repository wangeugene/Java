
//
//  TeslaTrackClipExporter.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/3/26.
//

import Foundation
import AVFoundation
import CoreMedia

enum TeslaTrackClipExportError: LocalizedError {
    case invalidDuration
    case exportSessionCreationFailed
    case unsupportedOutputFileType(String)
    case exportFailed(String)
    case exportCanceled

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
        }
    }
}

enum TeslaTrackClipExporter {
    static func exportClipAroundCurrentTime(
        from track: TeslaComposedTrack,
        currentTime: CMTime,
        duration: TimeInterval = 10,
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
//
//  MP4SampleReader.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/8/26.
//

import AVFoundation
import CoreMedia
import Foundation

struct MP4SampleReader {
    func readVideoSamples(from clipURL: URL) async throws -> [Data] {
        let asset = AVURLAsset(url: clipURL)
        let videoTracks = try await asset.loadTracks(withMediaType: .video)

        guard let videoTrack = videoTracks.first else {
            throw BitstreamError.noVideoTrack
        }

        let reader: AVAssetReader
        do {
            reader = try AVAssetReader(asset: asset)
        } catch {
            throw BitstreamError.assetReaderCreationFailed
        }

        let output = AVAssetReaderTrackOutput(
            track: videoTrack,
            outputSettings: nil
        )
        output.alwaysCopiesSampleData = false

        guard reader.canAdd(output) else {
            throw BitstreamError.assetReaderCreationFailed
        }
        reader.add(output)

        guard reader.startReading() else {
            throw BitstreamError.assetReaderStartFailed
        }

        var samples: [Data] = []
        var sampleIndex = 0

        while let sampleBuffer = output.copyNextSampleBuffer() {
            defer { sampleIndex += 1 }

            guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else {
                print("MP4SampleReader: sample \(sampleIndex) has no CMBlockBuffer")
                continue
            }

            let length = CMBlockBufferGetDataLength(blockBuffer)
            guard length > 0 else {
                print("MP4SampleReader: sample \(sampleIndex) has zero-length block buffer")
                continue
            }

            var totalLength = 0
            var dataPointer: UnsafeMutablePointer<Int8>?
            let pointerStatus = CMBlockBufferGetDataPointer(
                blockBuffer,
                atOffset: 0,
                lengthAtOffsetOut: nil,
                totalLengthOut: &totalLength,
                dataPointerOut: &dataPointer
            )

            if pointerStatus == kCMBlockBufferNoErr,
               let dataPointer,
               totalLength > 0 {
                let data = Data(bytes: dataPointer, count: totalLength)
                samples.append(data)
                continue
            }

            var data = Data(count: length)
            let copyStatus = data.withUnsafeMutableBytes { rawBuffer in
                guard let baseAddress = rawBuffer.baseAddress else {
                    return OSStatus(-12731) // CoreMedia bad parameter fallback
                }
                return CMBlockBufferCopyDataBytes(
                    blockBuffer,
                    atOffset: 0,
                    dataLength: length,
                    destination: baseAddress
                )
            }

            if copyStatus == kCMBlockBufferNoErr {
                samples.append(data)
            } else {
                print("MP4SampleReader: failed to copy sample \(sampleIndex), pointerStatus=\(pointerStatus), copyStatus=\(copyStatus)")
            }
        }

        switch reader.status {
        case .completed:
            return samples
        case .failed:
            print("MP4SampleReader: reader failed with error: \(reader.error?.localizedDescription ?? "nil")")
            throw reader.error ?? BitstreamError.invalidSample
        case .cancelled:
            throw BitstreamError.assetReaderStartFailed
        case .reading:
            // If we're still in the reading state but copyNextSampleBuffer() returned nil,
            // treat it as an unexpected end of stream.
            print("MP4SampleReader: reader still reading but no more samples available")
            throw BitstreamError.invalidSample
        case .unknown:
            print("MP4SampleReader: reader UNKNOWN")
            throw BitstreamError.invalidSample
        @unknown default:
            print("MP4SampleReader: finished in unexpected status \(reader.status.rawValue)")
            throw BitstreamError.invalidSample
        }
    }
}

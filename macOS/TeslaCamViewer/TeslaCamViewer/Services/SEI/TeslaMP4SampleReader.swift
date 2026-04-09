import AVFoundation
import CoreMedia
import Foundation

struct TeslaMP4SampleReader {
    // [length][NAL][length][NAL][length][NAL]... return: Data = [length][NAL]
    func readVideoSamples(from clipURL: URL) async throws -> [Data] {
        let asset = AVURLAsset(url: clipURL)
        let videoTracks = try await asset.loadTracks(withMediaType: .video)

        guard let videoTrack = videoTracks.first else {
            throw NSError(
                domain: "TeslaMP4SampleReader",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "No video track found in file: \(clipURL.path)"]
            )
        }

        let reader: AVAssetReader
        do {
            reader = try AVAssetReader(asset: asset)
        } catch {
            throw NSError(
                domain: "TeslaMP4SampleReader",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Failed to create AVAssetReader: \(error.localizedDescription)"]
            )
        }

        let output = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: nil)
        output.alwaysCopiesSampleData = false

        guard reader.canAdd(output) else {
            throw NSError(
                domain: "TeslaMP4SampleReader",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Cannot add AVAssetReaderTrackOutput to reader."]
            )
        }
        reader.add(output)

        guard reader.startReading() else {
            throw NSError(
                domain: "TeslaMP4SampleReader",
                code: 4,
                userInfo: [NSLocalizedDescriptionKey: "Failed to start reading samples."]
            )
        }

        var samples: [Data] = []
        var sampleIndex = 0

        while let sampleBuffer = output.copyNextSampleBuffer() {
            defer { sampleIndex += 1 }

            guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else {
                print("TeslaMP4SampleReader: sample \(sampleIndex) has no CMBlockBuffer")
                continue
            }

            let length = CMBlockBufferGetDataLength(blockBuffer)
            guard length > 0 else {
                print("TeslaMP4SampleReader: sample \(sampleIndex) has zero-length block buffer")
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
            let copyStatus = data.withUnsafeMutableBytes { rawBuffer -> OSStatus in
                guard let baseAddress = rawBuffer.baseAddress else {
                    return OSStatus(-12731)
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
                print("TeslaMP4SampleReader: failed to copy sample \(sampleIndex), pointerStatus=\(pointerStatus), copyStatus=\(copyStatus)")
            }
        }

        switch reader.status {
        case .completed:
            return samples
        case .failed:
            throw reader.error ?? NSError(
                domain: "TeslaMP4SampleReader",
                code: 5,
                userInfo: [NSLocalizedDescriptionKey: "Reader failed with unknown error."]
            )
        case .cancelled:
            throw NSError(
                domain: "TeslaMP4SampleReader",
                code: 6,
                userInfo: [NSLocalizedDescriptionKey: "Reader was cancelled."]
            )
        default:
            throw NSError(
                domain: "TeslaMP4SampleReader",
                code: 7,
                userInfo: [NSLocalizedDescriptionKey: "Reader finished in unexpected status: \(reader.status.rawValue)"]
            )
        }
    }
}

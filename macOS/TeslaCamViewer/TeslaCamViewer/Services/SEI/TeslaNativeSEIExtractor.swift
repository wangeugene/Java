import Foundation
import TeslaProtoModels
import SwiftProtobuf

struct TeslaNativeSEIExtractor: TeslaSEIExtracting {
    private let sampleReader = TeslaMP4SampleReader()
    private let nalParser = NALUnitParser()
    private let payloadDecoder = TeslaSEIPayloadDecoder()
    private let protobufDecoder = TeslaSEIProtobufDecoder()
    private let telemetryDecoder = TeslaTelemetryDecoder()


    
    func extract(from clipURL: URL) async throws -> [TeslaSEISample] {
        let samples = try await sampleReader.readVideoSamples(from: clipURL)
        var results: [TeslaSEISample] = []

        print("The clipURL used by TeslaNativeSEIExtractor: \(clipURL)")
        print("Samples offered by TeslaMP4SampleReader: \(samples.count)")
        for sample in samples {
            let nalUnits = try nalParser.parseNALUnits(from: sample)
            var seiCount = 0
            for nal in nalUnits {
                guard case .sei = nal.type else { continue }
                seiCount += 1
                guard nal.payload.count >= 2 else { continue }
                guard nal.payload[1] == 5 else { continue }
                
                if let rbsp = extractTeslaProtoPayload(from: nal.payload),
                   let sample = protobufDecoder.decode(from: rbsp, sourceClipURL: clipURL) {
                    results.append(sample)
                }
            }
        }
        return results
    }
    
    
    private func extractTeslaProtoPayload(from nalData: Data) -> Data? {
        guard nalData.count >= 4 else { return nil }

        for i in 3..<(nalData.count - 1) {
            let byte = nalData[i]
            if byte == 0x42 {
                continue
            }
            if byte == 0x69 {
                if i > 2 {
                    let ebsp = nalData[(i + 1)..<(nalData.count - 1)]
                    // Tesla official extractor slices out the protobuf bytes first,
                    // then removes emulation-prevention bytes from that slice.
                    return removeEmulationPreventionBytes(from: Data(ebsp))
                }
                break
            }
            break
        }
        return nil
    }

    private func removeEmulationPreventionBytes(from data: Data) -> Data {
        var stripped = Data()
        stripped.reserveCapacity(data.count)

        var zeroCount = 0

        for byte in data {
            if zeroCount >= 2 && byte == 0x03 {
                zeroCount = 0
                continue
            }

            stripped.append(byte)
            zeroCount = (byte == 0x00) ? (zeroCount + 1) : 0
        }

        return stripped
    }

}

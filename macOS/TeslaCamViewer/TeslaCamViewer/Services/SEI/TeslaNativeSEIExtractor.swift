import Foundation

struct TeslaNativeSEIExtractor: TeslaSEIExtracting {
    private let sampleReader = TeslaMP4SampleReader()
    private let nalParser = NALUnitParser()
    private let payloadDecoder = TeslaSEIPayloadDecoder()
    private let telemetryDecoder = TeslaTelemetryDecoder()

    func extract(from clipURL: URL) async throws -> [TeslaSEISample] {
        let samples = try await sampleReader.readVideoSamples(from: clipURL)
        var results: [TeslaSEISample] = []

        for (_, sample) in samples.enumerated() {
            let nalUnits = try nalParser.parseNALUnits(from: sample)
            var seiCount = 0
            for nal in nalUnits {
                if case .sei = nal.type {
                    seiCount += 1
                } else {
                    continue
                }
                // Split SEI into messages
                let seiPayload = Data(nal.payload.dropFirst())
                let messages = payloadDecoder.decodeSEI(from: seiPayload)
                print("sei count found in a sample: \(seiCount)")
                print("messages count from a nal.payload: \(messages.count)")
                for message in messages {
                    if let sample = telemetryDecoder.decode(from: message, sourceClipURL: clipURL) {
                        results.append(sample)
                    }
                }
            }
        }
        return results
    }
}

//
//  TimelineTelemetryProvider.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/11/26.
//


import Foundation

actor TimelineTelemetryProvider: TelemetryProviding {
    private let samples: [VehicleTelemetrySample]

    init(samples: [VehicleTelemetrySample]) {
        self.samples = samples.sorted { $0.timestamp < $1.timestamp }
    }

    func sample(at playbackTime: TimeInterval) async -> VehicleTelemetrySample? {
        guard !samples.isEmpty else { return nil }

        // simplest version: nearest sample
        var best = samples[0]
        var bestDistance = abs(samples[0].timestamp - playbackTime)

        for sample in samples.dropFirst() {
            let distance = abs(sample.timestamp - playbackTime)
            if distance < bestDistance {
                best = sample
                bestDistance = distance
            }
        }

        return best
    }
}

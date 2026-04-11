//
//  TelemetryOverlayViewModel.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/11/26.
//


import Foundation
import Observation
import Combine

@MainActor
final class TelemetryOverlayViewModel: ObservableObject {
    @Published private(set) var overlayModel: TelemetryOverlay = .preview

    private let telemetryProvider: TelemetryProviding

    init(telemetryProvider: TelemetryProviding) {
        self.telemetryProvider = telemetryProvider
    }

    func update(playbackTime: TimeInterval) {
        Task {
            let sample = await telemetryProvider.sample(at: playbackTime)
            let newModel = Self.makeOverlayModel(from: sample)
            await MainActor.run {
                self.overlayModel = newModel
            }
        }
    }

    private static func makeOverlayModel(from sample: VehicleTelemetrySample?) -> TelemetryOverlay {
        guard let sample else {
            return .preview
        }

        return TelemetryOverlay(
            gearText: sample.gear.rawValue,
            speedText: String(Int(sample.speedKmh.rounded())),
            unitText: "km/h",
            autopilotActive: sample.autopilotActive,
            leftBlinkerVisible: sample.leftBlinkerVisible,
            rightBlinkerVisible: sample.rightBlinkerVisible,
            throttleValue: sample.throttleValue.clamped(to: 0...1),
            brakeValue: sample.brakeValue.clamped(to: 0...1),
            steeringAngleValue: sample.steeringAngleValue.rounded()
        )
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

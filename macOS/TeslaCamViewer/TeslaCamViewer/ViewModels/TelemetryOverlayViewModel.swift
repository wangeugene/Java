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
            version: nil,
            gearState: "GEAR_" + sample.gear.rawValue.uppercased(),
            frameSequenceNumber: nil,
            vehicleSpeedMps: sample.speedKmh / 3.6,
            acceleratorPedalPosition: sample.throttleValue * 100.0,
            steeringWheelAngle: sample.steeringAngleValue,
            blinkerOnLeft: sample.leftBlinkerVisible,
            blinkerOnRight: sample.rightBlinkerVisible,
            brakeApplied: sample.brakeValue > 0,
            autopilotState: sample.autopilotActive ? "AUTOPILOT" : "NONE",
            latitudeDeg: nil,
            longitudeDeg: nil,
            headingDeg: nil,
            linearAccelerationMps2X: nil,
            linearAccelerationMps2Y: nil,
            linearAccelerationMps2Z: nil,
            sourceClipURL: nil
        )
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

import Foundation
import TeslaProtoModels
import SwiftProtobuf

struct TeslaSEIProtobufDecoder {
    func decode(from rbsp: Data, sourceClipURL: URL) -> TeslaSEISample? {
        do {
            let metadata = try SeiMetadata(serializedBytes: rbsp)

            return TeslaSEISample(
                version: Int(metadata.version),
                gearState: mapGearState(metadata.gearState),
                frameSequenceNumber: Int(metadata.frameSeqNo),
                vehicleSpeedMps: Double(metadata.vehicleSpeedMps),
                acceleratorPedalPosition: Double(metadata.acceleratorPedalPosition),
                steeringWheelAngle: Double(metadata.steeringWheelAngle),
                blinkerOnLeft: metadata.blinkerOnLeft,
                blinkerOnRight: metadata.blinkerOnRight,
                brakeApplied: metadata.brakeApplied,
                autopilotState: mapAutopilotState(metadata.autopilotState),
                latitudeDeg: metadata.latitudeDeg == 0 ? nil : metadata.latitudeDeg,
                longitudeDeg: metadata.longitudeDeg == 0 ? nil : metadata.longitudeDeg,
                headingDeg: metadata.headingDeg == 0 ? nil : metadata.headingDeg,
                linearAccelerationMps2X: metadata.linearAccelerationMps2X == 0 ? nil : metadata.linearAccelerationMps2X,
                linearAccelerationMps2Y: metadata.linearAccelerationMps2Y == 0 ? nil : metadata.linearAccelerationMps2Y,
                linearAccelerationMps2Z: metadata.linearAccelerationMps2Z == 0 ? nil : metadata.linearAccelerationMps2Z,
                sourceClipURL: sourceClipURL
            )
        } catch {
            print("Failed to decode SeiMetadata protobuf:", error.localizedDescription)
            return nil
        }
    }

    private func mapGearState(_ gear: SeiMetadata.Gear) -> String? {
        switch gear {
        case .park: return "GEAR_PARK"
        case .drive: return "GEAR_DRIVE"
        case .reverse: return "GEAR_REVERSE"
        case .neutral: return "GEAR_NEUTRAL"
        case .UNRECOGNIZED(let raw): return "UNRECOGNIZED(\(raw))"
        @unknown default:
            return "UNKNOWN"
        }
    }

    private func mapAutopilotState(_ state: SeiMetadata.AutopilotState) -> String? {
        switch state {
        case .none: return "NONE"
        case .selfDriving: return "SELF_DRIVING"
        case .autosteer: return "AUTOSTEER"
        case .tacc: return "TACC"
        case .UNRECOGNIZED(let raw): return "UNRECOGNIZED(\(raw))"
        @unknown default:
            return "UNKNOWN"
        }
    }
}

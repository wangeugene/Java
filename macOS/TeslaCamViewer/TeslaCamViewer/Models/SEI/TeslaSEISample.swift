import Foundation

struct TeslaSEISample: Hashable {
    let version: Int?
    let gearState: String?
    let frameSequenceNumber: Int?
    let vehicleSpeedMps: Double?
    let acceleratorPedalPosition: Double?
    let steeringWheelAngle: Double?
    let blinkerOnLeft: Bool?
    let blinkerOnRight: Bool?
    let brakeApplied: Bool?
    let autopilotState: String?
    let latitudeDeg: Double?
    let longitudeDeg: Double?
    let headingDeg: Double?
    let linearAccelerationMps2X: Double?
    let linearAccelerationMps2Y: Double?
    let linearAccelerationMps2Z: Double?
    let sourceClipURL: URL?
}

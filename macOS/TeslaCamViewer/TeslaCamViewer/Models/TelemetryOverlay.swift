//
//  TelemetryOverlayModel.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/11/26.
//


import Foundation

struct TelemetryOverlay: Codable, Equatable {
    var version: Int?
    var gearState: String?
    var frameSequenceNumber: Int?
    var vehicleSpeedMps: Double?
    var acceleratorPedalPosition: Double?
    var steeringWheelAngle: Double?
    var blinkerOnLeft: Bool?
    var blinkerOnRight: Bool?
    var brakeApplied: Bool?
    var autopilotState: String?
    var latitudeDeg: Double?
    var longitudeDeg: Double?
    var headingDeg: Double?
    var linearAccelerationMps2X: Double?
    var linearAccelerationMps2Y: Double?
    var linearAccelerationMps2Z: Double?
    var sourceClipURL: URL?
    
    static let preview = TelemetryOverlay(
        version: 1,
        gearState: "GEAR_DRIVE",
        frameSequenceNumber: 2004179,
        vehicleSpeedMps: 20.911,
        acceleratorPedalPosition: 22.8,
        steeringWheelAngle: 1.9,
        blinkerOnLeft: true,
        blinkerOnRight: true,
        brakeApplied: false,
        autopilotState: "NONE",
        linearAccelerationMps2X: 0.262,
        linearAccelerationMps2Y: 0.076,
        linearAccelerationMps2Z: 0.360
    )
}

extension TelemetryOverlay {
    var gearText: String {
        switch gearState {
        case "GEAR_DRIVE": return "D"
        case "GEAR_REVERSE": return "R"
        case "GEAR_PARK": return "P"
        case "GEAR_NEUTRAL": return "N"
        default: return ""
        }
    }
    
    var speedText: String {
        guard let vehicleSpeedMps = vehicleSpeedMps else { return "0" }
        return String(Int((vehicleSpeedMps * 3.6).rounded()))
    }
    
    var unitText: String {
        return "km/h"
    }
    
    var autopilotActive: Bool {
        return autopilotState != "NONE" && autopilotState != "UNKNOWN" && autopilotState != nil
    }
    
    var leftBlinkerVisible: Bool {
        return blinkerOnLeft ?? false
    }
    
    var rightBlinkerVisible: Bool {
        return blinkerOnRight ?? false
    }
    
    var throttleValue: Double {
        guard let pedal = acceleratorPedalPosition else { return 0.0 }
        return max(0, min(1, pedal / 100.0))
    }
    
    var brakeValue: Double {
        return (brakeApplied ?? false) ? 1.0 : 0.0
    }
    
    var steeringAngleValue: Double {
        return steeringWheelAngle ?? 0.0
    }
}

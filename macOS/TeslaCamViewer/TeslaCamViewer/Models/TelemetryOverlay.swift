//
//  TelemetryOverlayModel.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/11/26.
//


import Foundation

struct TelemetryOverlay: Equatable {
    var gearText: String
    var speedText: String
    var unitText: String
    var autopilotActive: Bool
    var leftBlinkerVisible: Bool
    var rightBlinkerVisible: Bool
    var throttleValue: Double
    var brakeValue: Double
    var steeringAngleValue: Double
    
    
    static let preview = TelemetryOverlay(
           gearText: "D",
           speedText: "54",
           unitText: "km/h",
           autopilotActive: false,
           leftBlinkerVisible: true,
           rightBlinkerVisible: true,
           throttleValue: 0.5,
           brakeValue: 0,
           steeringAngleValue: 0.1
    )
}

//
//  VehicleTelemetrySample.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/11/26.
//

import Foundation



struct VehicleTelemetrySample: Equatable, Sendable {
    let timestamp: TimeInterval
    let speedKmh: Double
    let gear: GearState
    let autopilotActive: Bool
    let leftBlinkerVisible: Bool
    let rightBlinkerVisible: Bool
    let throttleValue: Double      // 0...1
    let brakeValue: Double         // 0...1
    let steeringAngleValue: Double // degrees
}

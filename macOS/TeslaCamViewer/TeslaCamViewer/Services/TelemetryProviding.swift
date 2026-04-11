//
//  TelemetryProviding.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/11/26.
//


import Foundation

protocol TelemetryProviding: Sendable {
    func sample(at playbackTime: TimeInterval) async -> VehicleTelemetrySample?
}
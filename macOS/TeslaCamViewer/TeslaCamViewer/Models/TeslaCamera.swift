//
//  TeslaCamera.swift
//  TeslaCamViewer
//

import Foundation

enum TeslaCamera: String, Hashable, CaseIterable {
    case front
    case back
    case leftRepeater
    case rightRepeater
    case leftPillar
    case rightPillar
    case unknown

    var displayName: String {
        switch self {
        case .front: return "Front"
        case .back: return "Back"
        case .leftRepeater: return "Left Repeater"
        case .rightRepeater: return "Right Repeater"
        case .leftPillar: return "Left Pillar"
        case .rightPillar: return "Right Pillar"
        case .unknown: return "Unknown"
        }
    }
}

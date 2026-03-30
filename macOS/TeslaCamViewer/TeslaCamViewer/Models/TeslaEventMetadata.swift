//
//  TeslaEventMetadata.swift
//  TeslaCamViewer
//

import Foundation

struct TeslaEventMetadata: Codable, Hashable {
    let timestamp: String
    let city: String
    let street: String
    let estLat: String
    let estLon: String
    let reason: String
    let camera: String

    enum CodingKeys: String, CodingKey {
        case timestamp
        case city
        case street
        case estLat = "est_lat"
        case estLon = "est_lon"
        case reason
        case camera
    }

    var coordinateDescription: String {
        "\(estLat), \(estLon)"
    }
}
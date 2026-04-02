//
//  TeslaCameraTrack.swift
//  TeslaCamViewer
//  One TeslaCameraTrack maps to many TeslaCameraClips
//  Created by euwang on 4/2/26.
//

import Foundation

struct TeslaCameraTrack: Identifiable, Hashable {
    let camera: TeslaCamera
    let clips: [TeslaCameraClip]
    let eventID: URL   // 👈 add this

    var id: String {
        "\(eventID.path)|\(camera.rawValue)"
    }
}

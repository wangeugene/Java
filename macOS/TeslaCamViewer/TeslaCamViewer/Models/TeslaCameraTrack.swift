//
//  TeslaCameraTrack.swift
//  TeslaCamViewer
//  One TeslaCameraTrack maps to many TeslaCameraClips
//  Created by euwang on 4/2/26.
//


struct TeslaCameraTrack: Identifiable, Hashable {
    let camera: TeslaCamera
    let clips: [TeslaCameraClip]

    var id: String { camera.rawValue }
}

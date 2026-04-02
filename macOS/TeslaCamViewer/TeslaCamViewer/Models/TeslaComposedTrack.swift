//
//  TeslaComposedTrack.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/2/26.
//


import AVFoundation
import CoreMedia
import Foundation

struct TeslaComposedTrack {
    let camera: TeslaCamera
    let composition: AVMutableComposition
    let playerItem: AVPlayerItem
    let segments: [TeslaTrackSegment]
    let totalDuration: CMTime
    let startDate: Date?
}

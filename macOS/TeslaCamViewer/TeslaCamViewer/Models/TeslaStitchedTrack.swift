//
//  TeslaStitchedTrack.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/2/26.
//

import CoreMedia

struct TeslaStitchedTrack: Identifiable {
    let id: String
    let camera: TeslaCamera
    let segments: [TeslaTrackSegment]
    let totalDuration: CMTime
}

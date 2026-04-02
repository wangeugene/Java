//
//  TeslaTrackSegment.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/2/26.
//


import CoreMedia

struct TeslaTrackSegment: Identifiable, Hashable {
    let id: URL
    let sourceClip: TeslaCameraClip
    let timelineStart: CMTime
    let timelineDuration: CMTime

    var timelineEnd: CMTime {
        timelineStart + timelineDuration
    }
}

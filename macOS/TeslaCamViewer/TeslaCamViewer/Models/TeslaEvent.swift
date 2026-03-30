//
//  TeslaEvent.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import Foundation

struct TeslaEvent: Identifiable, Hashable {
    let id: URL
    let folderURL: URL
    let eventName: String
    let thumbnailURL: URL?
    let eventJSONURL: URL?
    let clips: [TeslaCameraClip]

    var representativeVideoURL: URL? {
        clips.first(where: { $0.camera == .front })?.url ?? clips.first?.url
    }
}

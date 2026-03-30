//
//  VideoClip.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import Foundation

struct VideoClip: Identifiable, Hashable {
    let id: URL
    let url: URL
    let thumbnailURL: URL?

    var fileName: String {
        url.lastPathComponent
    }
}

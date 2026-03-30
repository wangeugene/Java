//
//  SelectedVideo.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//

import AVKit
import AppKit

struct SelectedVideo: Identifiable, Hashable {
    let id: URL
    let url: URL

    var fileName: String {
        url.lastPathComponent
    }
}

//
//  TeslaEvent.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import Foundation

struct TeslaEvent: Identifiable, Hashable {
    var id: URL {
        folderURL
    }
    let folderURL: URL
    let eventName: String
    let thumbnailURL: URL?
    let eventJSONURL: URL?
    let clips: [TeslaCameraClip]

    var representativeVideoURL: URL? {
        clips.first(where: { $0.camera == .front })?.url ?? clips.first?.url
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"

        if let date = formatter.date(from: folderURL.lastPathComponent) {
            let output = DateFormatter()
            output.dateFormat = "MMM d, HH:mm"
            return output.string(from: date)
        }

        return folderURL.lastPathComponent
    }
}

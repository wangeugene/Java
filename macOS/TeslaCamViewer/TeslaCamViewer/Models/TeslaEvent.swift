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
    let order: [TeslaCamera] = [.front, .back, .leftRepeater, .rightRepeater, .leftPillar, .rightPillar]


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

/*
   This extension
 */
extension TeslaEvent {
    var tracks: [TeslaCameraTrack] {
        Dictionary(grouping: clips, by: \.camera)
            .map { camera, clips in
                TeslaCameraTrack(
                    camera: camera,
                    clips: clips.sorted { ($0.timestamp ?? .distantPast) < ($1.timestamp ?? .distantPast) },
                    eventID: self.id
                )
            }
            .sorted {
                order.firstIndex(of: $0.camera)! < order.firstIndex(of: $1.camera)!
            }

    }

    func track(for camera: TeslaCamera) -> TeslaCameraTrack? {
        tracks.first { $0.camera == camera }
    }
}

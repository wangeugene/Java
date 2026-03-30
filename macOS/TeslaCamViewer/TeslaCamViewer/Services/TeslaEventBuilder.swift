//
//  TeslaEventBuilder.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//

import Foundation

enum TeslaEventBuilder {
    static func buildEvents(from folders: [TeslaEventFolder]) -> [TeslaEvent] {
        folders.compactMap { buildEvent(from: $0) }
    }

    private static func buildEvent(from folder: TeslaEventFolder) -> TeslaEvent? {
        let fm = FileManager.default

        guard let contents = try? fm.contentsOfDirectory(
            at: folder.url,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else {
            return nil
        }

        let thumbnail = contents.first { $0.lastPathComponent == "thumb.png" }
        let json = contents.first { $0.lastPathComponent == "event.json" }

        let videos = contents.filter { $0.pathExtension.lowercased() == "mp4" }

        let clips: [TeslaCameraClip] = videos.map { url in
            TeslaCameraClip(
                id: url,
                url: url,
                timestamp: parseTimestamp(from: url.lastPathComponent),
                camera: parseCamera(from: url.lastPathComponent)
            )
        }

        return TeslaEvent(
            folderURL: folder.url,
            eventName: folder.name,
            thumbnailURL: thumbnail,
            eventJSONURL: json,
            clips: clips
        )
    }
}

private func parseCamera(from fileName: String) -> TeslaCamera {
        let name = fileName.lowercased()
        if name.contains("-front") { return .front }
        if name.contains("-back") { return .back }
        if name.contains("left_repeater") { return .leftRepeater }
        if name.contains("right_repeater") { return .rightRepeater }
        if name.contains("left_pillar") { return .leftPillar }
        if name.contains("right_pillar") { return .rightPillar }
        return .unknown
    }

private func parseTimestamp(from fileName: String) -> Date? {
        let base = fileName.replacingOccurrences(of: ".mp4", with: "")
        let parts = base.split(separator: "-")
        guard parts.count >= 3 else { return nil }
        let ts = parts.dropLast().joined(separator: "-")
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.date(from: ts)
    }

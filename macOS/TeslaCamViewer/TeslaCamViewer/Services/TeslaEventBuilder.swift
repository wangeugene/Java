//
//  TeslaEventBuilder.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//

import Foundation

enum TeslaEventBuilder {
    nonisolated static func buildEvents(from folderURLs: [URL]) -> [TeslaEvent] {
        folderURLs.compactMap(buildEvent(from:))
    }
    
    nonisolated private static func buildEvent(from folderURL: URL) -> TeslaEvent? {
        let fm = FileManager.default
        
        guard let contents = try? fm.contentsOfDirectory(
            at: folderURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else {
            return nil
        }
        
        let thumbnailURL = contents.first { $0.lastPathComponent == "thumb.png" }
        let eventJSONURL = contents.first { $0.lastPathComponent == "event.json" }
        
        let videoURLs = contents
            .filter { $0.pathExtension.lowercased() == "mp4" }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
        
        let clips = videoURLs.map { url in
            TeslaCameraClip(
                id: url,
                url: url,
                timestamp: parseTimestamp(from: url.lastPathComponent),
                camera: parseCamera(from: url.lastPathComponent)
            )
        }
        
        return TeslaEvent(
            folderURL: folderURL,
            eventName: folderURL.lastPathComponent,
            thumbnailURL: thumbnailURL,
            eventJSONURL: eventJSONURL,
            clips: clips
        )
    }
    
    
    nonisolated private static func parseCamera(from fileName: String) -> TeslaCamera {
        let name = fileName.lowercased()
        if name.contains("-front") { return .front }
        if name.contains("-back") { return .back }
        if name.contains("left_repeater") { return .leftRepeater }
        if name.contains("right_repeater") { return .rightRepeater }
        if name.contains("left_pillar") { return .leftPillar }
        if name.contains("right_pillar") { return .rightPillar }
        return .unknown
    }
    
    nonisolated private static func parseTimestamp(from fileName: String) -> Date? {
        let base = fileName.replacingOccurrences(of: ".mp4", with: "")
        let parts = base.split(separator: "-")
        guard parts.count >= 3 else { return nil }
        let ts = parts.dropLast().joined(separator: "-")
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.date(from: ts)
    }
}


//
//  TeslaEventRepository.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


//
//  TeslaEventRepository.swift
//  TeslaCamViewer
//

import Foundation

struct TeslaEventRepository {
    func loadEvents(rootURL: URL, group: TeslaClipGroup) -> [TeslaEvent] {
        let folderURLs = TeslaCamScanner.eventFolderURLs(in: rootURL, group: group)
        return TeslaEventBuilder.buildEvents(from: folderURLs)
    }

    func loadMetadata(for event: TeslaEvent) -> TeslaEventMetadata? {
        TeslaEventJSONLoader.loadMetadata(from: event.eventJSONURL)
    }
}

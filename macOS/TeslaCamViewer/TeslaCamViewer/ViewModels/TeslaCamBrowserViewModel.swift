//
//  TeslaCamBrowserViewModel.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class TeslaCamBrowserViewModel: ObservableObject {
    @Published var rootURL: URL?
    @Published var groups: [TeslaClipGroup] = []
    @Published var selectedGroup: TeslaClipGroup?
    @Published var events: [TeslaEvent] = []
    @Published var selectedEvent: TeslaEvent?
    @Published var selectedEventMetadata: TeslaEventMetadata?
    @Published private(set) var metadataByEventID: [URL: TeslaEventMetadata] = [:]
    private let repository = TeslaEventRepository()

    func load(rootURL: URL) {
        self.rootURL = rootURL
        groups = TeslaCamScanner.existingGroups(in: rootURL)
        selectGroup(groups.first)
    }

    func selectGroup(_ group: TeslaClipGroup?) {
        guard selectedGroup != group else { return }
        selectedGroup = group
        reloadEvents()
    }
    
    func selectEvent(_ event: TeslaEvent?) {
        guard selectedEvent != event else { return }
        selectedEvent = event
    }

    func metadata(for event: TeslaEvent) -> TeslaEventMetadata? {
        metadataByEventID[event.id]
    }


    private func reloadEvents() {
        guard let rootURL, let selectedGroup else {
            events = []
            metadataByEventID = [:]
            selectedEvent = nil
            selectedEventMetadata = nil
            return
        }

        let loadedEvents = repository.loadEvents(rootURL: rootURL, group: selectedGroup)
        let loadedMetadata = Dictionary(uniqueKeysWithValues: loadedEvents.compactMap { event in
            repository.loadMetadata(for: event).map { (event.id, $0) }
        })

        events = loadedEvents
        metadataByEventID = loadedMetadata
        selectEvent(loadedEvents.first)
    }
    
}


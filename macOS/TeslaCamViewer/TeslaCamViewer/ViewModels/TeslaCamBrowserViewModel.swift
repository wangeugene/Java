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

    private func reloadEvents() {
        guard let rootURL, let selectedGroup else {
            events = []
            selectedEvent = nil
            return
        }

        print("rootURL: \(rootURL), group: \(selectedGroup)")
        let evenFolderUrls = TeslaCamScanner.eventFolderURLs(in: rootURL, group: selectedGroup)
        events = TeslaEventBuilder.buildEvents(from: evenFolderUrls)
        selectedEvent = events.first
    }
}

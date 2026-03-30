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
    @Published var eventFolders: [TeslaEventFolder] = []
    @Published var selectedEvent: TeslaEventFolder?

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

    func selectEvent(_ event: TeslaEventFolder?) {
        guard selectedEvent != event else { return }
        selectedEvent = event
    }

    private func reloadEvents() {
        guard let rootURL, let selectedGroup else {
            eventFolders = []
            selectedEvent = nil
            return
        }

        eventFolders = TeslaCamScanner.eventFolders(in: rootURL, group: selectedGroup)
        selectedEvent = eventFolders.first
    }
}

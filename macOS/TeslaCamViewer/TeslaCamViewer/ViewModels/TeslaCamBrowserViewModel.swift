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
    
    func debugReadSamples() {
        let clipURL = URL(fileURLWithPath: "/Users/euwang/Downloads/TeslaCam/SavedClips/2026-04-05_15-57-50/2026-04-05_15-46-55-front.mp4")

        Task {
            do {
                let reader = MP4SampleReader()
                let samples = try await reader.readVideoSamples(from: clipURL)
                print("Sample count:", samples.count)
                print("First sample size:", samples.first?.count ?? 0)
            } catch {
                print("Sample read failed:", error.localizedDescription)
            }
        }
    }
    
    func debugParseNALUnits() {
        let clipURL = URL(fileURLWithPath: "/Users/euwang/Downloads/TeslaCam/SavedClips/2026-04-05_15-57-50/2026-04-05_15-46-55-front.mp4")

        Task {
            do {
                let reader = MP4SampleReader()
                let parser = NALUnitParser()

                let samples = try await reader.readVideoSamples(from: clipURL)
                print("Sample count:", samples.count)

                if let firstSample = samples.first {
                    let nalUnits = try parser.parseNALUnits(from: firstSample)
                    print("First sample NAL count:", nalUnits.count)

                    for (index, nal) in nalUnits.prefix(10).enumerated() {
                        print("NAL \(index):", nal.type)
                    }
                }
            } catch {
                print("NAL parse failed:", error.localizedDescription)
            }
        }
    }
    
}


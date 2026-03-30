//
//  EventFolderListView.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import SwiftUI
import AppKit

struct EventFolderListView: View {
    @ObservedObject var viewModel: TeslaCamBrowserViewModel
    @State private var selectedEvent: TeslaEvent?

    var body: some View {
        List(selection: $selectedEvent) {
            ForEach(viewModel.events) { event in
                EventThumbnailView(
                    event: event,
                    metadata: viewModel.metadata(for: event)
                )
                    .tag(event)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedEvent = event
                    }
            }
        }
        .navigationTitle(viewModel.selectedGroup?.displayName ?? "Events")
        .onAppear {
            selectedEvent = viewModel.selectedEvent
        }
        .onChange(of: selectedEvent) { _, newValue in
            DispatchQueue.main.async {
                viewModel.selectEvent(newValue)
            }
        }
        .onChange(of: viewModel.selectedEvent) { _, newValue in
            if selectedEvent != newValue {
                selectedEvent = newValue
            }
        }
        .onChange(of: viewModel.events) { _, _ in
            selectedEvent = viewModel.selectedEvent
        }
    }
}

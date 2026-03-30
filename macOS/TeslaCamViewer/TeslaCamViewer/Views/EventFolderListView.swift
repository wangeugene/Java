//
//  EventFolderListView.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import SwiftUI

struct EventFolderListView: View {
    @ObservedObject var viewModel: TeslaCamBrowserViewModel
    @State private var selectedEvent: TeslaEventFolder?

    var body: some View {
        List(selection: $selectedEvent) {
            ForEach(viewModel.eventFolders) { event in
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.name)
                        .font(.body)

                    if let date = event.date {
                        Text(date.formatted(date: .abbreviated, time: .standard))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .tag(event)
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
        .onChange(of: viewModel.eventFolders) { _, _ in
            selectedEvent = viewModel.selectedEvent
        }
    }
}

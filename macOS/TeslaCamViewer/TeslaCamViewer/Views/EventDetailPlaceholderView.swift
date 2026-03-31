//
//  EventDetailPlaceholderView.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//

import SwiftUI
import AppKit

struct EventDetailPlaceholderView: View {
    @ObservedObject var viewModel: TeslaCamBrowserViewModel

    var body: some View {
        Group {
            if let event = viewModel.selectedEvent {
                EventDetailContentView(
                    event: event,
                    metadata: viewModel.metadata(for: event)
                )
            } else {
                ContentUnavailableView(
                    "No Folder Selected",
                    systemImage: "folder",
                    description: Text("Choose a TeslaCam group and an event folder.")
                )
            }
        }
    }
}


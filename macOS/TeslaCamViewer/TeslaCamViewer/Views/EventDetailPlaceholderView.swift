//
//  EventDetailPlaceholderView.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import SwiftUI

struct EventDetailPlaceholderView: View {
    @ObservedObject var viewModel: TeslaCamBrowserViewModel

    var body: some View {
        Group {
            if let event = viewModel.selectedEvent {
                VStack(alignment: .leading, spacing: 12) {
                    Text(event.name)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(event.url.path)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()
                }
                .padding()
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

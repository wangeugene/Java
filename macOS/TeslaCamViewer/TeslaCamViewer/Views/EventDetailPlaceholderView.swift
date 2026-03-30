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
                VStack(alignment: .leading, spacing: 12) {
                    if let thumbnailURL = event.thumbnailURL,
                       let nsImage = NSImage(contentsOf: thumbnailURL) {
                        Image(nsImage: nsImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                    } else {
                        ContentUnavailableView(
                            "No Thumbnail",
                            systemImage: "photo",
                            description: Text("This event does not contain a preview image.")
                        )
                    }

                    Text(event.folderURL.path)
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

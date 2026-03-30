//
//  VideoDetailPane.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import SwiftUI
import AVKit

struct VideoDetailPane: View {
    @ObservedObject var viewModel: VideoBrowserViewModel

    var body: some View {
        Group {
            if let clip = viewModel.selectedClip {
                VStack(alignment: .leading, spacing: 16) {
                    Text(clip.fileName)
                        .font(.headline)

                    VideoPlayer(player: viewModel.player)
                        .frame(minHeight: 320)

                    Spacer()
                }
                .padding()
            } else {
                ContentUnavailableView(
                    "No Video Selected",
                    systemImage: "video",
                    description: Text("Choose a clip from the list on the left.")
                )
            }
        }
    }
}
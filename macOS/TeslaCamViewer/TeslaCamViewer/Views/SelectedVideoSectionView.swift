//
//  SelectedVideoSection.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//

import SwiftUI
import AVKit

struct SelectedVideoSectionView: View {
    let video: SelectedVideo
    @ObservedObject var viewModel: VideoPlaybackViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text("Selected file:")

            Text(video.fileName)
                .font(.caption)
                .foregroundColor(.gray)

            VideoPlayer(player: viewModel.player)
                .frame(height: 400)

            Button(viewModel.isExporting ? "Exporting..." : "Burn Timestamp & Save to Documents") {
                Task {
                    await viewModel.exportSelectedVideo()
                }
            }
            .disabled(viewModel.isExporting)

            if let exportStatus = viewModel.exportStatus {
                Text(exportStatus)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

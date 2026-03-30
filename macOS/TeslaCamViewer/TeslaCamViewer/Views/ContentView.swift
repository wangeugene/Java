import SwiftUI
import AVKit
import AppKit



struct ContentView: View {
    @StateObject private var viewModel = VideoPlaybackViewModel()

    var body: some View {
        VStack(spacing: 20) {
            selectButton

            if let video = viewModel.selectedVideo {
                SelectedVideoSection(video: video, viewModel: viewModel)
            } else {
                emptyStateView
            }
        }
        .padding()
        .frame(minWidth: 800, minHeight: 600)
    }

    private var selectButton: some View {
        Button("Select MP4 File") {
            viewModel.selectVideo()
        }
    }
}


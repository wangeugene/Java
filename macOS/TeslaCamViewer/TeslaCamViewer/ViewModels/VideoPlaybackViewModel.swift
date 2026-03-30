//
//  VideoPlaybackViewModel.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//
import SwiftUI
import AVKit
import AppKit
import Combine


@MainActor
final class VideoPlaybackViewModel: ObservableObject {
    @Published var selectedVideo: SelectedVideo?
    @Published var isExporting = false
    @Published var exportStatus: String?
    @Published var lastOutputURL: URL?

    let player = AVPlayer()

    func selectVideo() {
        guard let url = FilePicker.pickVideo() else { return }

        selectedVideo = SelectedVideo(id: url, url: url)
        exportStatus = nil
        lastOutputURL = nil
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        print("Selected:", url)
    }

    func exportSelectedVideo() async {
        guard let url = selectedVideo?.url else { return }

        isExporting = true
        exportStatus = "Preparing export..."

        do {
            let outputURL = try await TimestampBurner.exportVideoWithTimestamp(from: url)
            lastOutputURL = outputURL
            exportStatus = "Saved to \(outputURL.path)"
        } catch {
            exportStatus = "Export failed: \(error.localizedDescription)"
        }

        isExporting = false
    }

    func openProcessedFile() {
        guard let lastOutputURL else { return }
        NSWorkspace.shared.open(lastOutputURL)
    }
}

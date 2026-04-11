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
   
    let player = AVPlayer()


    func exportSelectedVideo() async {
        guard let url = selectedVideo?.url else { return }

        isExporting = true
        exportStatus = "Preparing export..."

        do {
            let outputURL = try await TimestampBurner.exportVideoWithTimestamp(from: url)
            exportStatus = "Saved to \(outputURL.path)"
        } catch {
            exportStatus = "Export failed: \(error.localizedDescription)"
        }

        isExporting = false
    }
    
}

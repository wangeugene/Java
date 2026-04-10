//
//  EventDetailHeaderView.swift
//  TeslaCamViewer
//

import SwiftUI
import AppKit
import AVKit

struct EventDetailHeaderView: View {
    let event: TeslaEvent
    let metadata: TeslaEventMetadata?
    let selectedTrack: TeslaCameraTrack?
    @ObservedObject var playbackViewModel: EventDetailPlaybackViewModel

    @State private var exportStatusMessage: String?
    @State private var isExportingSnapshot = false
    @State private var isExportingClip = false

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(event.eventName)
                    .font(.title2)
                    .fontWeight(.semibold)

                if let metadata = metadata {
                    Text("\(metadata.city) · \(metadata.street) · \(metadata.timestamp)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text(event.folderURL.path)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .textSelection(.enabled)
                }
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 10) {
                Button(isExportingSnapshot ? "Exporting..." : "Export JPG") {
                    Task {
                        await exportCurrentFrameAsJPEG()
                    }
                }
                .disabled(isExportingSnapshot || playbackViewModel.composedTrack == nil)

                Button(isExportingClip ? "Exporting..." : "Export 10s MP4") {
                    Task {
                        await exportCurrent10SecondClipAsMP4()
                    }
                }
                .disabled(isExportingClip || playbackViewModel.composedTrack == nil)

                Button("Open Last Export") {
                    playbackViewModel.openLastExport()
                }
                .disabled(
                    playbackViewModel.lastExportedClipURL == nil &&
                    playbackViewModel.lastExportedSnapshotURL == nil
                )
                
                Button("Open Last Export Finder Folder") {
                    playbackViewModel.openLastExportFolder()
                }
                .disabled(
                    playbackViewModel.lastExportedClipURL == nil &&
                    playbackViewModel.lastExportedSnapshotURL == nil
                )
                
                Button("Test Sample Reader") {
                    playbackViewModel.debugReadSamples()
                }
                    
                Button("Test Extract Native SEI") {
                    if let track = selectedTrack,
                       let clipURL = track.clips.first?.url {
                        playbackViewModel.debugExtractNativeSEI(from: clipURL)
                    } else {
                        print("No selected track or clip available")
                    }
                }
            }
        }
    }

    private func suggestedSnapshotFilename() -> String {
        let rawTimestamp = playbackViewModel.overlayTimestampText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !rawTimestamp.isEmpty else {
            return "\(event.eventName).jpg"
        }

        let timeOnly: String
        if let lastComponent = rawTimestamp.split(separator: " ").last {
            timeOnly = String(lastComponent)
        } else {
            timeOnly = rawTimestamp
        }

        let safeTimeOnly = timeOnly.replacingOccurrences(of: ":", with: "-")

        // Extract date part (YYYY-MM-DD) from overlay or fallback to event metadata
        let datePart: String
        if let firstComponent = rawTimestamp.split(separator: " ").first, firstComponent.contains("-") {
            datePart = String(firstComponent)
        }
        else if let metadataTimestamp = metadata?.timestamp {
            datePart = metadataTimestamp.split(separator: " ").first.map(String.init) ?? "unknown-date"
        }
        else {
            datePart = "unknown-date"
        }

        return "\(datePart)_\(safeTimeOnly)_snapshot.jpg"
    }

    @MainActor
    private func exportCurrentFrameAsJPEG() async {
        guard !isExportingSnapshot else { return }
        guard let composedTrack = playbackViewModel.composedTrack else {
            exportStatusMessage = "No composed track available to export."
            return
        }

        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        let snapshotFilename = suggestedSnapshotFilename()
        savePanel.nameFieldStringValue = snapshotFilename
        savePanel.allowedContentTypes = [.jpeg]
        savePanel.isExtensionHidden = false
        savePanel.title = "Export Snapshot"
        savePanel.message = "Choose where to save the current frame as a JPEG image."

        guard savePanel.runModal() == .OK, let outputURL = savePanel.url else {
            exportStatusMessage = "Export canceled."
            return
        }

        isExportingSnapshot = true
        exportStatusMessage = nil

        do {
            try await TeslaTrackFrameExporter.exportJPEGSnapshot(
                from: composedTrack,
                at: playbackViewModel.player.currentTime(),
                overlayTimestampText: playbackViewModel.overlayTimestampText,
                metadata: metadata,
                to: outputURL
            )
            playbackViewModel.lastExportedSnapshotURL = outputURL
            exportStatusMessage = "Saved JPEG to \(outputURL.lastPathComponent)"
        } catch {
            exportStatusMessage = "Export failed: \(error.localizedDescription)"
        }

        isExportingSnapshot = false
    }

    @MainActor
    private func exportCurrent10SecondClipAsMP4() async {
        guard !isExportingClip else { return }
        guard let composedTrack = playbackViewModel.composedTrack else {
            exportStatusMessage = "No composed track available to export."
            return
        }

        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.nameFieldStringValue = "\(event.eventName)-10s.mp4"
        savePanel.allowedContentTypes = [.mpeg4Movie]
        savePanel.isExtensionHidden = false
        savePanel.title = "Export 10-Second Clip"
        savePanel.message = "Choose where to save a 10-second MP4 clip centered on the current playback time."

        guard savePanel.runModal() == .OK, let outputURL = savePanel.url else {
            exportStatusMessage = "Export canceled."
            return
        }

        isExportingClip = true
        exportStatusMessage = nil

        do {
            try await TeslaTrackClipExporter.exportClipAroundCurrentTime(
                from: composedTrack,
                currentTime: playbackViewModel.player.currentTime(),
                duration: 10,
                overlayCurrentTimestampText: playbackViewModel.overlayTimestampText,
                outputURL: outputURL
            )
            playbackViewModel.lastExportedClipURL = outputURL
            exportStatusMessage = "Saved MP4 to \(outputURL.lastPathComponent)"
        } catch {
            exportStatusMessage = "Export failed: \(error.localizedDescription)"
        }

        isExportingClip = false
    }
}

//
//  EventDetailContentView.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/31/26.
//

import SwiftUI
import AppKit
import AVKit

struct EventDetailContentView: View {
    let event: TeslaEvent
    let metadata: TeslaEventMetadata?

    @StateObject private var playbackViewModel = EventDetailPlaybackViewModel()
    @State private var selectedTrack: TeslaCameraTrack?
    @State private var timelineValue: Double = 0
    @State private var videoAspectRatio: CGFloat = 16.0 / 9.0
    @State private var exportStatusMessage: String?
    @State private var isExportingSnapshot = false
    @State private var isExportingClip = false



    private var mainTrack: TeslaCameraTrack? {
        selectedTrack
        ?? event.track(for: .front)
        ?? event.tracks.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            mainPreviewSection
            previewStrip
            timelineSection
            footer
        }
        .padding(20)
        .frame(maxWidth: 980, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            selectedTrack = mainTrack
        }
        .onChange(of: event.id) { _, _ in
            selectedTrack = event.track(for: .front) ?? event.tracks.first
            timelineValue = 0
        }
        .onChange(of: selectedTrackLoadKey) { _, _ in
            guard let track = selectedTrack else {
                playbackViewModel.player.replaceCurrentItem(with: nil)
                return
            }

            Task {
                await updateAspectRatio(for: track)   // 👈 HERE
                await playbackViewModel.load(track: track)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(event.eventName)
                    .font(.title2)
                    .fontWeight(.semibold)

                if let metadata {
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
            }
        }
    }

    
    private var selectedTrackLoadKey: String {
        let eventKey = event.id.path
        let cameraKey = selectedTrack?.camera.rawValue ?? "none"
        let clipKey = selectedTrack?.clips.first?.id.path ?? "no-clips"
        return "\(eventKey)|\(cameraKey)|\(clipKey)"
    }
    
    private var mainPreviewSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.9))

            if playbackViewModel.composedTrack != nil {
                VideoPlayer(player: playbackViewModel.player)
                    .id(selectedTrackLoadKey)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(alignment: .topLeading) {
                        if !playbackViewModel.overlayTimestampText.isEmpty {
                            Text(playbackViewModel.overlayTimestampText)
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0), in: Capsule())
                                .padding(14)
                        }
                    }
            } else if let thumbnailURL = event.thumbnailURL,
                      let nsImage = NSImage(contentsOf: thumbnailURL) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .padding(24)
            } else {
                ContentUnavailableView(
                    "No Preview",
                    systemImage: "video",
                    description: Text("This event does not contain a playable preview.")
                )
                .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: 980, alignment: .leading)
        .aspectRatio(videoAspectRatio, contentMode: .fit)
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 8) {
                if let errorMessage = playbackViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.red.opacity(0.85), in: RoundedRectangle(cornerRadius: 10))
                }

                if let exportStatusMessage {
                    Text(exportStatusMessage)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.72), in: RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(14)
        }
    }

    private var previewStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(event.tracks) { track in
                    Button {
                        selectedTrack = track
                    } label: {
                        TrackPreviewCard(
                            track: track,
                            event: event,
                            isSelected: track.id == mainTrack?.id
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Timeline")
                .font(.caption)
                .foregroundColor(.secondary)

            Slider(value: $timelineValue, in: 0...1)
                .disabled(playbackViewModel.composedTrack == nil)

            HStack {
                Text("00:00")
                Spacer()
                Text(mainTrack?.camera.displayName ?? "No Track")
                Spacer()
                Text(totalDurationText)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }

    private var totalDurationText: String {
        guard let totalDuration = playbackViewModel.composedTrack?.totalDuration.seconds,
              totalDuration.isFinite else {
            return "--:--"
        }

        let totalSeconds = Int(totalDuration.rounded())
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Event Folder")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(event.folderURL.path)
                .font(.caption)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
        }
    }
   
    @MainActor
    private func updateAspectRatio(for track: TeslaCameraTrack) async {
        let sortedClips = track.clips.sorted {
            ($0.timestamp ?? .distantPast) < ($1.timestamp ?? .distantPast)
        }

        guard let firstClipURL = sortedClips.first?.url else {
            return   // ❗ no fallback overwrite
        }

        do {
            let asset = AVURLAsset(url: firstClipURL)
            let videoTracks = try await asset.loadTracks(withMediaType: .video)

            guard let videoTrack = videoTracks.first else {
                return
            }

            let naturalSize = try await videoTrack.load(.naturalSize)
            let preferredTransform = try await videoTrack.load(.preferredTransform)
            let transformedSize = naturalSize.applying(preferredTransform)

            let width = abs(transformedSize.width)
            let height = abs(transformedSize.height)

            // ✅ THIS is where your snippet goes
            if width > 0, height > 0 {
                videoAspectRatio = width / height
            }

        } catch {
            // ❗ do nothing → keep last ratio
        }
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
        savePanel.nameFieldStringValue = "\(event.eventName).jpg"
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

private struct TrackPreviewCard: View {
    let track: TeslaCameraTrack
    let event: TeslaEvent
    let isSelected: Bool

    private var firstClip: TeslaCameraClip? {
        track.clips.sorted { ($0.timestamp ?? .distantPast) < ($1.timestamp ?? .distantPast) }.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.16))
                    .frame(width: 132, height: 74)
                    .overlay {
                        previewBackground
                    }

                LinearGradient(
                    colors: [Color.black.opacity(0.72), Color.clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(width: 132, height: 74)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(track.camera.displayName)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .padding(8)
            }

            Text(firstClip?.timestamp.map(Self.timeFormatter.string(from:)) ?? event.formattedDate)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(10)
        .background(cardBackground)
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.18), lineWidth: isSelected ? 2 : 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private var previewBackground: some View {
        if let thumbnailURL = event.thumbnailURL,
           let nsImage = NSImage(contentsOf: thumbnailURL) {
            Image(nsImage: nsImage)
                .resizable()
                .scaledToFill()
                .frame(width: 132, height: 74)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            Image(systemName: "video")
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(isSelected ? Color.accentColor.opacity(0.08) : Color.clear)
    }

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}

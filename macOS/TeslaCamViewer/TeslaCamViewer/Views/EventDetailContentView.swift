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
                                .background(Color.black.opacity(0.72), in: Capsule())
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
        .overlay(alignment: .topTrailing) {
            if let mainTrack {
                Label(mainTrack.camera.displayName, systemImage: "play.rectangle")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(14)
            }
        }
        .overlay(alignment: .bottomLeading) {
            if let errorMessage = playbackViewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.red.opacity(0.85), in: RoundedRectangle(cornerRadius: 10))
                    .padding(14)
            }
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
                    .onAppear {
                            print("Track ID:", track.id)
                        }
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

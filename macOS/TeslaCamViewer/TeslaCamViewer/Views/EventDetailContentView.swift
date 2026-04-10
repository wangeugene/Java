//
//  EventDetailContentView.swift
//  TeslaCamViewer
//
//
//  Created by euwang on 3/31/26.

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
            mainPreviewSection
            previewStrip
        }
        .frame(minWidth: 720, maxWidth: 980, alignment: .leading)
        .padding(10)
        .frame(minWidth: 960, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .task(id: event.id) {
            await playbackViewModel.load(event: event)
            if let track = event.track(for: .front) ?? event.tracks.first {
                selectedTrack = track
                timelineValue = 0
            }
        }
        .onChange(of: selectedTrackLoadKey) { _, _ in
            guard let track = selectedTrack else { return }
            Task {
                await updateAspectRatio(for: track)
                await playbackViewModel.select(track: track)
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
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(alignment: .topTrailing) {
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
        .frame(minHeight: 480, alignment: .leading)
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
                            isSelected: track.id == mainTrack?.id,
                            player: playbackViewModel.trackPlayers[track.id]
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
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

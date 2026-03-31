//
//  EventDetailContentView.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/31/26.
//

import SwiftUI
import AppKit

struct EventDetailContentView: View {
    let event: TeslaEvent
    let metadata: TeslaEventMetadata?

    @State private var selectedClip: TeslaCameraClip?
    @State private var timelineValue: Double = 0

    private var mainClip: TeslaCameraClip? {
        selectedClip
        ?? event.clips.first(where: { $0.camera == .front })
        ?? event.clips.first
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            selectedClip = mainClip
        }
        .onChange(of: event.id) { _, _ in
            selectedClip = event.clips.first(where: { $0.camera == .front }) ?? event.clips.first
            timelineValue = 0
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

    private var mainPreviewSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.9))

            if let url = mainClip?.url {
                VideoPlayerView(url: url)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
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
        .frame(maxWidth: .infinity)
        .frame(height: 360)
        .overlay(alignment: .topLeading) {
            if let mainClip {
                Label(mainClip.camera.displayName, systemImage: "play.rectangle")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(14)
            }
        }
    }

    private var previewStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(event.clips) { clip in
                    Button {
                        selectedClip = clip
                    } label: {
                        ClipPreviewCard(
                            clip: clip,
                            event: event,
                            isSelected: clip.id == mainClip?.id
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
                .disabled(mainClip == nil)

            HStack {
                Text("00:00")
                Spacer()
                Text(mainClip?.camera.displayName ?? "No Clip")
                Spacer()
                Text("--:--")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
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
}

private struct ClipPreviewCard: View {
    let clip: TeslaCameraClip
    let event: TeslaEvent
    let isSelected: Bool

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

                Text(clip.camera.displayName)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .padding(8)
            }

            Text(clip.timestamp.map(Self.timeFormatter.string(from:)) ?? event.formattedDate)
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

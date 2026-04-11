//
//  TrackPreviewCard.swift
//  TeslaCamViewer
//

import SwiftUI
import AppKit
import AVKit

struct TrackPreviewCardView: View {
    let track: TeslaCameraTrack
    let event: TeslaEvent
    let isSelected: Bool
    let player: AVPlayer?

    private var previewWidth: CGFloat { 132 }
    private var previewHeight: CGFloat { 74 }

    private var firstClip: TeslaCameraClip? {
        track.clips.sorted { ($0.timestamp ?? .distantPast) < ($1.timestamp ?? .distantPast) }.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.16))
                    .frame(width: previewWidth, height: previewHeight)
                    .overlay {
                        previewBackground
                    }

                LinearGradient(
                    colors: [Color.black.opacity(0.72), Color.clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(width: previewWidth, height: previewHeight)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(track.camera.displayName)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .padding(8)
            }

            Text(firstClip?.timestamp.map(TrackPreviewCardView.timeFormatter.string(from:)) ?? event.formattedDate)
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
        if let player = player {
            VideoPlayer(player: player)
                .disabled(true)
                .frame(width: previewWidth, height: previewHeight)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else if let thumbnailURL = event.thumbnailURL,
           let nsImage = NSImage(contentsOf: thumbnailURL) {
            Image(nsImage: nsImage)
                .resizable()
                .scaledToFill()
                .frame(width: previewWidth, height: previewHeight)
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

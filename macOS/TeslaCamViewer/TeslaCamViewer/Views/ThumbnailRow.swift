//
//  ThumbnailRow.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import SwiftUI

struct ThumbnailRow: View {
    let clip: VideoClip
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.quaternary)

                Text("Thumbnail")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(width: 110, height: 62)

            VStack(alignment: .leading, spacing: 4) {
                Text(clip.fileName)
                    .font(.subheadline)
                    .lineLimit(1)

                Text("Preview")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

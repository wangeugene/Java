//
//  VideoListPane.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import SwiftUI

struct VideoListPane: View {
    @ObservedObject var viewModel: VideoBrowserViewModel

    var body: some View {
        List(viewModel.clips, selection: selectedClipBinding) { clip in
            Button {
                viewModel.selectClip(clip)
            } label: {
                ThumbnailRow(clip: clip, isSelected: clip.id == viewModel.selectedClip?.id)
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Clips")
    }

    private var selectedClipBinding: Binding<VideoClip?> {
        Binding(
            get: { viewModel.selectedClip },
            set: { newValue in
                if let newValue {
                    viewModel.selectClip(newValue)
                }
            }
        )
    }
}
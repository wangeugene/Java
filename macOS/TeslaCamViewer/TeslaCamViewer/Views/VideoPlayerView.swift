//
//  VideoPlayerView.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/22/26.
//


import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    let url: URL
    
    @State private var player: AVPlayer
    
    init(url: URL) {
        self.url = url
        _player = State(initialValue: AVPlayer(url: url))
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}

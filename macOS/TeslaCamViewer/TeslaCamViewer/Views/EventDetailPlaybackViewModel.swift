//
//  EventDetailPlaybackViewModel.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/2/26.
//


import Foundation
import AVFoundation
import Combine

@MainActor
final class EventDetailPlaybackViewModel: ObservableObject {
    @Published var selectedTrack: TeslaCameraTrack?
    @Published var composedTrack: TeslaComposedTrack?
    @Published var errorMessage: String?

    let player = AVPlayer()

    func load(track: TeslaCameraTrack) async {
        do {
            let composed = try await TeslaTrackCompositionBuilder.build(from: track)
            selectedTrack = track
            composedTrack = composed
            errorMessage = nil
            player.replaceCurrentItem(with: composed.playerItem)
        } catch {
            errorMessage = error.localizedDescription
            composedTrack = nil
            player.replaceCurrentItem(with: nil)
        }
    }
}

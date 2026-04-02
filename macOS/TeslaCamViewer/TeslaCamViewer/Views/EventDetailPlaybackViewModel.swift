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
    @Published var overlayTimestampText: String = ""


    let player = AVPlayer()
    
    private var timeObserverToken: Any?

    deinit {
        let token = timeObserverToken
        let player = player

        if let token {
            Task { @MainActor in
                player.removeTimeObserver(token)
            }
        }
    }
    
    func load(track: TeslaCameraTrack) async {
        do {
            let composed = try await TeslaTrackCompositionBuilder.build(from: track)
            selectedTrack = track
            composedTrack = composed
            errorMessage = nil

            removeTimeObserver()
            player.pause()
            player.replaceCurrentItem(with: composed.playerItem)
            installTimeObserver()
            player.play()
        } catch {
            errorMessage = error.localizedDescription
            composedTrack = nil
            overlayTimestampText = ""
            player.replaceCurrentItem(with: nil)
        }
    }

    private func installTimeObserver() {
        let interval = CMTime(seconds: 0.2, preferredTimescale: 600)

        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] currentTime in
            guard let self else { return }
            Task { @MainActor [weak self] in
                self?.updateOverlayTimestamp(currentTime: currentTime)
            }
        }
    }

    private func removeTimeObserver() {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }

    private func updateOverlayTimestamp(currentTime: CMTime) {
        guard
            let startDate = composedTrack?.startDate,
            currentTime.isNumeric
        else {
            overlayTimestampText = ""
            return
        }

        let overlayDate = startDate.addingTimeInterval(currentTime.seconds)
        overlayTimestampText = Self.overlayFormatter.string(from: overlayDate)
    }

    private static let overlayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

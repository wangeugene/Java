//
//  EventDetailPlaybackViewModel.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/2/26.
//


import Foundation
import AVFoundation
import Combine
import AppKit

@MainActor
final class EventDetailPlaybackViewModel: ObservableObject {
    @Published var selectedTrack: TeslaCameraTrack?
    @Published var composedTrack: TeslaComposedTrack?
    @Published var errorMessage: String?
    @Published var overlayTimestampText: String = ""
    @Published var lastExportedClipURL: URL?
    @Published var lastExportedSnapshotURL: URL?

    // Master player for the main view
    let player = AVPlayer()
    
    // Mini players for the preview strip cards
    @Published private(set) var trackPlayers: [String: AVPlayer] = [:]
    
    private var allComposedTracks: [String: TeslaComposedTrack] = [:]
    
    nonisolated(unsafe) private var timeObserverToken: Any?
    nonisolated(unsafe) private var rateObserver: NSKeyValueObservation?

    deinit {
        rateObserver?.invalidate()
        if let token = timeObserverToken {
            let player = player
            DispatchQueue.main.async {
                player.removeTimeObserver(token)
            }
        }
    }
    
    func load(event: TeslaEvent) async {
        player.pause()
        for p in trackPlayers.values { p.pause() }
        
        do {
            var newComposed: [String: TeslaComposedTrack] = [:]
            var newPlayers: [String: AVPlayer] = [:]
            
            // Build player items for all mini track preview cards
            for track in event.tracks {
                let composed = try await TeslaTrackCompositionBuilder.build(from: track)
                newComposed[track.id] = composed
                
                let miniPlayer = AVPlayer(playerItem: composed.playerItem)
                miniPlayer.isMuted = true
                newPlayers[track.id] = miniPlayer
            }
            
            self.allComposedTracks = newComposed
            self.trackPlayers = newPlayers
            self.errorMessage = nil
            
        } catch {
            self.errorMessage = "Failed to load event tracks: \(error.localizedDescription)"
            self.allComposedTracks = [:]
            self.trackPlayers = [:]
        }
    }

    func select(track: TeslaCameraTrack) async {
        guard let _ = allComposedTracks[track.id] else { return }
        
        selectedTrack = track
        removeTimeObserver()
        rateObserver?.invalidate()
        player.pause()

        do {
            // Build a brand new AVPlayerItem for the master player since items cannot be shared
            let masterComposed = try await TeslaTrackCompositionBuilder.build(from: track)
            composedTrack = masterComposed
            
            player.replaceCurrentItem(with: masterComposed.playerItem)
            
            // Synchronize master player to whatever time the mini players are currently at
            if let firstMiniPlayer = trackPlayers.values.first {
                 await player.seek(to: firstMiniPlayer.currentTime(), toleranceBefore: .zero, toleranceAfter: .zero)
            }
            
            installTimeObserver()
            installRateObserver()
            
            player.play()
        } catch {
            errorMessage = "Failed to build master view: \(error.localizedDescription)"
            composedTrack = nil
            overlayTimestampText = ""
            player.replaceCurrentItem(with: nil)
        }
    }

    private func installRateObserver() {
        rateObserver = player.observe(\.rate, options: [.new]) { [weak self] player, change in
            guard let self = self, let rate = change.newValue else { return }
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                for p in self.trackPlayers.values {
                    if rate == 0 {
                        p.pause()
                    } else {
                        p.play()
                    }
                }
            }
        }
    }

    private func installTimeObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)

        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] currentTime in
            guard let self else { return }
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.updateOverlayTimestamp(currentTime: currentTime)
                
                // If paused (scrubbing), continuously sync mini players to the scrubbed time frame
                if self.player.rate == 0 {
                    for p in self.trackPlayers.values {
                        p.seek(to: currentTime, toleranceBefore: .zero, toleranceAfter: .zero)
                    }
                } else {
                    // Check for drift during playback
                    for p in self.trackPlayers.values {
                        let diff = abs(p.currentTime().seconds - currentTime.seconds)
                        if diff > 0.5 {
                            p.seek(to: currentTime, toleranceBefore: .zero, toleranceAfter: .zero)
                        }
                    }
                }
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
    
    func openLastExport() {
        if let url = lastExportedClipURL {
            NSWorkspace.shared.open(url)
        } else if let url = lastExportedSnapshotURL {
            NSWorkspace.shared.open(url)
        }
    }
    
    func openLastExportFolder() {
        if let fileURL = lastExportedClipURL {
            let folderURL = fileURL.deletingLastPathComponent()
            NSWorkspace.shared.open(folderURL)
        } else if let fileURL = lastExportedSnapshotURL {
            let folderURL = fileURL.deletingLastPathComponent()
            NSWorkspace.shared.open(folderURL)
        }
    }
    
    func debugExtractNativeSEI(from clipURL: URL) {
        print("incoming URL: \(clipURL.lastPathComponent)")
        Task {
            do {
                let extractor = TeslaNativeSEIExtractor()
                let samples = try await extractor.extract(from: clipURL)
                print("Native SEI extract sample count:", samples.count)
            } catch {
                print("Native SEI extract failed:", error.localizedDescription)
            }
        }
    }
    
    func debugReadSamples() {
        guard let firstClip = selectedTrack?.clips.first else { return }
        let clipURL = firstClip.url
        Task {
            do {
                let reader = TeslaMP4SampleReader()
                _ = try await reader.readVideoSamples(from: clipURL)
            } catch {
                print("Read failed:", error.localizedDescription)
            }
        }
    }
}

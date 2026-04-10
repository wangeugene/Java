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

    let player = AVPlayer()
    
    nonisolated(unsafe) private var timeObserverToken: Any?

    deinit {
        if let token = timeObserverToken {
            let player = player
            DispatchQueue.main.async {
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

                for (index, sample) in samples.prefix(5).enumerated() {
                    print("Decoded sample \(index):")
                    print("  sourceClipURL:", sample.sourceClipURL?.lastPathComponent ?? "nil")
                    print("  vehicleSpeedMps:", sample.vehicleSpeedMps as Any)
                    print("  accelX:", sample.linearAccelerationMps2X as Any)
                    print("  accelY:", sample.linearAccelerationMps2Y as Any)
                    print("  accelZ:", sample.linearAccelerationMps2Z as Any)
                    print("  latitudeDeg:", sample.latitudeDeg as Any)
                    print("  longitudeDeg:", sample.longitudeDeg as Any)
                }
            } catch {
                print("Native SEI extract failed:", error.localizedDescription)
            }
        }
    }
    
    func debugReadSamples() {
        guard let firstClip = selectedTrack?.clips.first
              else {
                    print("No clip available")
                return
                }

        let clipURL = firstClip.url

        Task {
            do {
                let reader = TeslaMP4SampleReader()
                let samples = try await reader.readVideoSamples(from: clipURL)

                print("Sample count:", samples.count)
                print("First sample size:", samples.first?.count ?? 0)

            } catch {
                print("Read failed:", error.localizedDescription)
            }
        }
    }
}

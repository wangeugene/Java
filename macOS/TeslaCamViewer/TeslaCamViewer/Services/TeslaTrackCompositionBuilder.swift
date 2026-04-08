//
//  TeslaTrackCompositionBuilder.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/2/26.
//

import Foundation
import AVFoundation
import CoreMedia
import CoreGraphics


enum TeslaTrackCompositionBuilder {
    static func build(from track: TeslaCameraTrack) async throws -> TeslaComposedTrack {
        let sortedClips = track.clips.sorted {
            ($0.timestamp ?? .distantPast) < ($1.timestamp ?? .distantPast)
        }
        
        let startDate = sortedClips.first?.timestamp

        guard !sortedClips.isEmpty else {
            throw TeslaTrackCompositionError.emptyTrack
        }

        let composition = AVMutableComposition()

        guard let videoCompositionTrack = composition.addMutableTrack(
            withMediaType: .video,
            preferredTrackID: kCMPersistentTrackID_Invalid
        ) else {
            throw TeslaTrackCompositionError.compositionTrackCreationFailed
        }

        var currentTimelineStart = CMTime.zero
        var segments: [TeslaTrackSegment] = []
        var referencePreferredTransform: CGAffineTransform?
        var referenceDisplaySize: CGSize?

        for clip in sortedClips {
            let asset = AVURLAsset(url: clip.url)
            let sourceVideoTracks = try await asset.loadTracks(withMediaType: .video)

            guard let sourceVideoTrack = sourceVideoTracks.first else {
                throw TeslaTrackCompositionError.missingVideoTrack(clip.url)
            }

            let naturalSize = try await sourceVideoTrack.load(.naturalSize)
            let preferredTransform = try await sourceVideoTrack.load(.preferredTransform)
            let transformedSize = naturalSize.applying(preferredTransform)
            let displaySize = CGSize(width: abs(transformedSize.width), height: abs(transformedSize.height))

            let duration = try await asset.load(.duration)
            let timeRange = CMTimeRange(start: .zero, duration: duration)

            if referencePreferredTransform == nil {
                referencePreferredTransform = preferredTransform
                referenceDisplaySize = displaySize
                videoCompositionTrack.preferredTransform = preferredTransform
            } else {
                if let referencePreferredTransform,
                   !transformsAreNearlyEqual(referencePreferredTransform, preferredTransform) {
                    print("⚠️ Transform mismatch detected for clip:", clip.url.lastPathComponent)
                    print("  reference:", referencePreferredTransform)
                    print("  current:", preferredTransform)
                }

                if let referenceDisplaySize,
                   (abs(referenceDisplaySize.width - displaySize.width) > 0.5 || abs(referenceDisplaySize.height - displaySize.height) > 0.5) {
                    print("⚠️ Display size mismatch detected for clip:", clip.url.lastPathComponent)
                    print("  reference:", referenceDisplaySize)
                    print("  current:", displaySize)
                }
            }

            do {
                try videoCompositionTrack.insertTimeRange(
                    timeRange,
                    of: sourceVideoTrack,
                    at: currentTimelineStart
                )
            } catch {
                throw TeslaTrackCompositionError.insertionFailed(clip.url, underlying: error)
            }

            segments.append(
                TeslaTrackSegment(
                    id: clip.id,
                    sourceClip: clip,
                    timelineStart: currentTimelineStart,
                    timelineDuration: duration
                )
            )

            currentTimelineStart = currentTimelineStart + duration
        }

        let playerItem = AVPlayerItem(asset: composition)

        return TeslaComposedTrack(
            camera: track.camera,
            composition: composition,
            playerItem: playerItem,
            segments: segments,
            totalDuration: currentTimelineStart,
            startDate: startDate
        )
    }
    private static func transformsAreNearlyEqual(
        _ lhs: CGAffineTransform,
        _ rhs: CGAffineTransform,
        tolerance: CGFloat = 0.0001
    ) -> Bool {
        abs(lhs.a - rhs.a) <= tolerance &&
        abs(lhs.b - rhs.b) <= tolerance &&
        abs(lhs.c - rhs.c) <= tolerance &&
        abs(lhs.d - rhs.d) <= tolerance &&
        abs(lhs.tx - rhs.tx) <= tolerance &&
        abs(lhs.ty - rhs.ty) <= tolerance
    }
}

//
//  TeslaTrackCompositionBuilder.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/2/26.
//


//
//  TeslaTrackCompositionBuilder.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/2/26.
//

import Foundation
import AVFoundation
import CoreMedia


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

        let audioCompositionTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: kCMPersistentTrackID_Invalid
        )

        var currentTimelineStart = CMTime.zero
        var segments: [TeslaTrackSegment] = []

        for clip in sortedClips {
            let asset = AVURLAsset(url: clip.url)
            let sourceVideoTracks = try await asset.loadTracks(withMediaType: .video)

            guard let sourceVideoTrack = sourceVideoTracks.first else {
                throw TeslaTrackCompositionError.missingVideoTrack(clip.url)
            }

            let duration = try await asset.load(.duration)
            let timeRange = CMTimeRange(start: .zero, duration: duration)

            do {
                try videoCompositionTrack.insertTimeRange(
                    timeRange,
                    of: sourceVideoTrack,
                    at: currentTimelineStart
                )
            } catch {
                throw TeslaTrackCompositionError.insertionFailed(clip.url, underlying: error)
            }

            let sourceAudioTracks = try await asset.loadTracks(withMediaType: .audio)

            if let sourceAudioTrack = sourceAudioTracks.first,
               let audioCompositionTrack {
                do {
                    try audioCompositionTrack.insertTimeRange(
                        timeRange,
                        of: sourceAudioTrack,
                        at: currentTimelineStart
                    )
                } catch {
                    throw TeslaTrackCompositionError.insertionFailed(clip.url, underlying: error)
                }
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
}

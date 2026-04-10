//
//  EventDetailTimelineView.swift
//  TeslaCamViewer
//

import SwiftUI
import CoreMedia

struct EventDetailTimelineView: View {
    @Binding var timelineValue: Double
    @ObservedObject var playbackViewModel: EventDetailPlaybackViewModel
    let mainTrack: TeslaCameraTrack?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Timeline")
                .font(.caption)
                .foregroundColor(.secondary)

            Slider(value: $timelineValue, in: 0...1)
                .disabled(playbackViewModel.composedTrack == nil)

            HStack {
                Text("00:00")
                Spacer()
                Text(mainTrack?.camera.displayName ?? "No Track")
                Spacer()
                Text(totalDurationText)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }

    private var totalDurationText: String {
        guard let totalDuration = playbackViewModel.composedTrack?.totalDuration.seconds,
              totalDuration.isFinite else {
            return "--:--"
        }

        let totalSeconds = Int(totalDuration.rounded())
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

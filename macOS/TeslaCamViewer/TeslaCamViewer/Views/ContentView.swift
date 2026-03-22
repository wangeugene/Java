import SwiftUI
import AVKit

struct ContentView: View {
    @State private var selectedVideoURL: URL?
    @State private var isExporting = false
    @State private var exportStatus: String?
    @State private var lastOutputURL: URL?

    private var player: AVPlayer? {
        guard let url = selectedVideoURL else { return nil }
        return AVPlayer(url: url)
    }

    var body: some View {
        VStack(spacing: 20) {
            Button("Select MP4 File") {
                if let url = FilePicker.pickVideo() {
                    selectedVideoURL = url
                    exportStatus = nil
                    lastOutputURL = nil
                    print("Selected:", url)
                }
            }

            if let url = selectedVideoURL {
                Text("Selected file:")
                Text(url.lastPathComponent)
                    .font(.caption)
                    .foregroundColor(.gray)

                if let player {
                    VideoPlayer(player: player)
                        .frame(height: 400)
                }

                Button(isExporting ? "Exporting..." : "Burn Timestamp & Save to Documents") {
                    Task {
                        await exportVideoWithTimestamp(from: url)
                    }
                }
                .disabled(isExporting)

                if let exportStatus {
                    Text(exportStatus)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                if let lastOutputURL {
                    Button("Open Processed File") {
                        NSWorkspace.shared.open(lastOutputURL)
                    }
                }
            } else {
                Text("No video selected")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(minWidth: 800, minHeight: 600)
    }

    @MainActor
    private func exportVideoWithTimestamp(from url: URL) async {
        isExporting = true
        exportStatus = "Preparing export..."

        do {
            let outputURL = try await TimestampBurner.exportVideoWithTimestamp(from: url)
            lastOutputURL = outputURL
            exportStatus = "Saved to \(outputURL.path)"
        } catch {
            exportStatus = "Export failed: \(error.localizedDescription)"
        }

        isExporting = false
    }
}


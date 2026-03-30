import SwiftUI
import AVKit
import AppKit



struct ContentView: View {
    @StateObject private var viewModel = VideoBrowserViewModel()
    @State private var selectedFolderURL: URL?

    var body: some View {
        HSplitView {
            VideoListPane(viewModel: viewModel)
                .frame(minWidth: 220, idealWidth: 260, maxWidth: 320)

            VideoDetailPane(viewModel: viewModel)
                .frame(minWidth: 500)
        }
        .frame(minWidth: 900, minHeight: 600)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Open SavedClips Folder") {
                    if let folderURL = FolderPicker.pickFolder() {
                        selectedFolderURL = folderURL
                        viewModel.loadVideos(from: folderURL)
                    }
                }
            }
        }
    }
}

private enum FolderPicker {
    static func pickFolder() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Choose SavedClips Folder"
        panel.message = "Select the Tesla SavedClips folder you want to browse."

        return panel.runModal() == .OK ? panel.url : nil
    }
}
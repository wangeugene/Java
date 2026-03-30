import SwiftUI
import AVKit
import AppKit


struct ContentView: View {
    @StateObject private var viewModel = TeslaCamBrowserViewModel()

    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: viewModel)
        } content: {
            EventFolderListView(viewModel: viewModel)
        } detail: {
            EventDetailPlaceholderView(viewModel: viewModel)
        }
        .frame(minWidth: 1000, minHeight: 650)
        .toolbar {
            Button("Open TeslaCam Folder") {
                if let url = FolderPicker.pickTeslaCamFolder() {
                    viewModel.load(rootURL: url)
                }
            }
        }
    }
}

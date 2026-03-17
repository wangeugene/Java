import SwiftUI

struct ContentView: View {
    @State private var sharedImage: UIImage?
    @State private var showingShareSheet = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            if let sharedImage {
                Image(uiImage: sharedImage)
                    .resizable()
                    .scaledToFit()

                Button("Share to WeChat") {
                    showingShareSheet = true
                }
            } else {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, eugene!")
            }

            Button("Close") {
                dismiss()
            }
        }
        .onAppear {
            sharedImage = AppGroupStorage.loadProcessedImage()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let sharedImage {
                ActivityView(activityItems: [sharedImage])
            }
        }
    }
}
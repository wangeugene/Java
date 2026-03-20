import SwiftUI

struct ContentView: View {
    @State private var sharedImage: UIImage?
    @State private var showingShareSheet = false

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
                Text("Hello, No screenshot has been shared to the PrivacyMask share extension!")
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

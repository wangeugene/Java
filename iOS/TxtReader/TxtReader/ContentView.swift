import SwiftUI

struct ContentView: View {
    @State private var statusMessage = "Opening book..."
    @State private var epubURL: URL?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerView
                        bookCardView
                        readingSurfaceView
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            loadBundledEPUB(named: "sherlock")
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Now Reading")
                .font(.caption)
                .textCase(.uppercase)
                .foregroundStyle(.secondary)

            Text(bookTitle)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .lineLimit(2)

            Text(bookSubtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bookCardView: some View {
        HStack(alignment: .top, spacing: 16) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.blue.gradient)
                .frame(width: 84, height: 118)
                .overlay {
                    VStack(spacing: 8) {
                        Image(systemName: "book.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                        Text("EPUB")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
                .shadow(radius: 6, y: 3)

            VStack(alignment: .leading, spacing: 10) {
                Label(epubURL?.lastPathComponent ?? "sherlock.epub", systemImage: "doc.text.fill")
                    .font(.headline)

                Label("App bundle", systemImage: "shippingbox.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var readingSurfaceView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Preview")
                    .font(.headline)
                Spacer()
                Text("Chapter 1")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(sampleReadingText)
                        .font(.system(size: 20, weight: .regular, design: .serif))
                        .foregroundStyle(.primary)
                        .lineSpacing(10)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let epubURL {
                        Divider()

                        Text("Bundled file path")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)

                        Text(epubURL.path)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 420)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    private var bookTitle: String {
        if let fileName = epubURL?.deletingPathExtension().lastPathComponent,
           !fileName.isEmpty {
            return prettifiedTitle(from: fileName)
        }
        return "Sherlock Holmes"
    }

    private var bookSubtitle: String {
        epubURL == nil ? "Waiting for bundled EPUB" : "A bundled EPUB ready for parsing"
    }

    private var sampleReadingText: String {
        if epubURL == nil {
            return "Your EPUB file has not been loaded yet. Once the file is found in the app bundle, this screen can transition from a visual reading layout into a real EPUB renderer backed by a parser library and WKWebView."
        }

        return "This screen now looks like a reading app instead of a loader panel. The current implementation still only resolves the EPUB file from the app bundle, but the layout is ready for the next step: parsing chapters and rendering real book content in a dedicated reading surface."
    }

    private func prettifiedTitle(from rawName: String) -> String {
        rawName
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { word in
                let lowercased = word.lowercased()
                if lowercased.allSatisfy({ $0.isNumber }) {
                    return String(word)
                }
                return lowercased.prefix(1).uppercased() + lowercased.dropFirst()
            }
            .joined(separator: " ")
    }

    private func loadBundledEPUB(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "epub") else {
            statusMessage = "Could not find \(name).epub in the app bundle. Check Target Membership for the file."
            epubURL = nil
            return
        }

        epubURL = url
        statusMessage = "Book loaded from the app bundle. Next step: pass this URL into your EPUB parser or reader library."
        print("Found EPUB at: \(url.path)")
    }
}

#Preview {
    ContentView()
}

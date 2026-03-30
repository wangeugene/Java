import SwiftUI
import AppKit

struct EventThumbnailView: View {
    let event: TeslaEvent

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            // Thumbnail image or fallback
            Group {
                if let thumbnailURL = event.thumbnailURL,
                   let nsImage = NSImage(contentsOf: thumbnailURL) {

                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFill()

                } else {

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay {
                            Image(systemName: "video")
                                .foregroundColor(.secondary)
                        }
                }
            }
            .frame(width: 192, height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Overlay: timestamp + event name
            VStack{
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.formattedDate)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                .padding(6)
                .foregroundColor(.white)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.7), Color.black.opacity(0.0)],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
            }
        }
        .frame(width: 192, height: 108)
    }
}

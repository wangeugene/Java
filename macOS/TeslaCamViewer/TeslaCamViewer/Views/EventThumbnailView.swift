import SwiftUI
import AppKit

struct EventThumbnailView: View {
    let event: TeslaEvent
    let metadata: TeslaEventMetadata?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
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

            LinearGradient(
                colors: [Color.black.opacity(0.75), Color.black.opacity(0.0)],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(width: 192, height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(event.formattedDate)
                    .font(.caption2)
                    .lineLimit(1)

                if let city = metadata?.city, let street = metadata?.street {
                    HStack{
                        Text(city)
                        Text(street)
                    }
                    .font(.caption2)
                    .lineLimit(1)
                }
            }
            .padding(8)
            .foregroundColor(.white)
        }
        .frame(width: 192, height: 108)
    }
}

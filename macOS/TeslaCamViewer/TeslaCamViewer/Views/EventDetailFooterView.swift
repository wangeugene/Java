//
//  EventDetailFooterView.swift
//  TeslaCamViewer
//

import SwiftUI

struct EventDetailFooterView: View {
    let event: TeslaEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Event Folder")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(event.folderURL.path)
                .font(.caption)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
        }
    }
}

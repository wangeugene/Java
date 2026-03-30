//
//  TeslaClipGroup.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import Foundation

enum TeslaClipGroup: String, CaseIterable, Identifiable {
    case recent = "RecentClips"
    case saved = "SavedClips"
    case sentry = "SentryClips"
    case encrypted = "EncryptedClips"

    var id: String { rawValue }

    var displayName: String { rawValue }
}

struct TeslaEventFolder: Identifiable, Hashable {
    let id: String
    let url: URL
    let name: String
    let date: Date?
}

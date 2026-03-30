//
//  VideoBrowserViewModel.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//

import Foundation
import AVKit
import Combine

@MainActor
final class VideoBrowserViewModel: ObservableObject {
    @Published var clips: [VideoClip] = []
    @Published var selectedClip: VideoClip?

    let player = AVPlayer()
    
    func loadVideos(from savedClipsFolderURL: URL) {
        let fileManager = FileManager.default

        do {
            let folderURLs = try fileManager.contentsOfDirectory(
                at: savedClipsFolderURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            let eventFolders = folderURLs.filter { url in
                var isDirectory: ObjCBool = false
                return fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
            }

            let loadedClips = eventFolders.compactMap { folderURL -> VideoClip? in
                guard let contents = try? fileManager.contentsOfDirectory(
                    at: folderURL,
                    includingPropertiesForKeys: nil,
                    options: [.skipsHiddenFiles]
                ) else {
                    return nil
                }

                let thumbnailURL = contents.first { $0.lastPathComponent == "thumb.png" }

                let preferredVideoURL = contents.first {
                    $0.pathExtension.lowercased() == "mp4" && $0.lastPathComponent.contains("-front")
                } ?? contents.first {
                    $0.pathExtension.lowercased() == "mp4"
                }

                guard let videoURL = preferredVideoURL else {
                    return nil
                }

                return VideoClip(
                    id: folderURL,
                    url: videoURL,
                    thumbnailURL: thumbnailURL
                )
            }
            .sorted { $0.id.lastPathComponent > $1.id.lastPathComponent }

            clips = loadedClips

            if let firstClip = loadedClips.first {
                selectClip(firstClip)
            } else {
                selectedClip = nil
                player.replaceCurrentItem(with: nil)
            }
        } catch {
            print("Failed to load videos from folder: \(savedClipsFolderURL.path)")
            print("Error: \(error.localizedDescription)")
            clips = []
            selectedClip = nil
            player.replaceCurrentItem(with: nil)
        }
    }

    func selectClip(_ clip: VideoClip) {
        selectedClip = clip
        player.replaceCurrentItem(with: AVPlayerItem(url: clip.url))
    }
}

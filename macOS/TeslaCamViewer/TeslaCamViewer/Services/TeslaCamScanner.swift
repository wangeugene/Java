//
//  TeslaCamScanner.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import Foundation

enum TeslaCamScanner {
    static func existingGroups(in rootURL: URL) -> [TeslaClipGroup] {
        let fm = FileManager.default

        return TeslaClipGroup.allCases.filter { group in
            var isDirectory: ObjCBool = false
            let url = rootURL.appendingPathComponent(group.rawValue, isDirectory: true)
            return fm.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
        }
    }

    static func eventFolders(in rootURL: URL, group: TeslaClipGroup) -> [TeslaEventFolder] {
        let fm = FileManager.default
        let groupURL = rootURL.appendingPathComponent(group.rawValue, isDirectory: true)

        guard let urls = try? fm.contentsOfDirectory(
            at: groupURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        return urls
            .filter { url in
                var isDirectory: ObjCBool = false
                return fm.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
            }
            .map { url in
                TeslaEventFolder(
                    id: url.path,
                    url: url,
                    name: url.lastPathComponent,
                    date: parseTeslaFolderDate(from: url.lastPathComponent)
                )
            }
            .sorted {
                ($0.date ?? .distantPast) > ($1.date ?? .distantPast)
            }
    }

    private static func parseTeslaFolderDate(from folderName: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.date(from: folderName)
    }
}
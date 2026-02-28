import Foundation
import UIKit

enum ImageStore {
    // Returns the app's Documents directory URL
    static func documentsDirectoryURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // Returns (and creates if needed) a subfolder inside Documents
    static func imagesDirectoryURL(subfolder: String = "Photos") throws -> URL {
        let dir = documentsDirectoryURL().appendingPathComponent(subfolder, isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    // Save a UIImage as JPEG into Documents/subfolder and return the file URL
    @discardableResult
    static func saveJPEG(_ image: UIImage,
                         subfolder: String = "Photos",
                         compressionQuality: CGFloat = 0.9,
                         fileName: String? = nil) throws -> URL {
        let folderURL = try imagesDirectoryURL(subfolder: subfolder)
        let name = fileName ?? Self.defaultFileName()
        let fileURL = folderURL.appendingPathComponent(name).appendingPathExtension("jpg")
        guard let data = image.jpegData(compressionQuality: compressionQuality) else {
            throw NSError(domain: "ImageStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create JPEG data"])
        }
        try data.write(to: fileURL, options: .atomic)
        return fileURL
    }

    // List saved images in the subfolder
    static func listImages(subfolder: String = "Photos") -> [URL] {
        let folderURL = try? imagesDirectoryURL(subfolder: subfolder)
        guard let folderURL else { return [] }
        let contents = (try? FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)) ?? []
        return contents.filter { ["jpg", "jpeg", "png"].contains($0.pathExtension.lowercased()) }
    }

    // Helper to generate a readable unique filename
    private static func defaultFileName() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return "IMG_" + formatter.string(from: Date()).replacingOccurrences(of: ":", with: "-")
    }
}

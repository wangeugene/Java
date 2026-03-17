//
//  AppGroupStorage.swift
//  PrivacyMask
//
//  Created by euwang on 3/16/26.
//


import Foundation
import UIKit

enum AppGroupStorage {
    static let groupID = "group.com.eugene.PrivacyMask"
    static let processedImageFileName = "processed-image.jpg"

    static var containerURL: URL {
        guard let url = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: groupID
        ) else {
            fatalError("Could not resolve App Group container URL for \(groupID)")
        }
        return url
    }

    static var processedImageURL: URL {
        containerURL.appendingPathComponent(processedImageFileName)
    }

    @discardableResult
    static func saveProcessedImage(
        _ image: UIImage,
        compressionQuality: CGFloat = 0.9
    ) throws -> URL {
        guard let data = image.jpegData(compressionQuality: compressionQuality) else {
            throw StorageError.failedToEncodeJPEG
        }

        try data.write(to: processedImageURL, options: .atomic)
        return processedImageURL
    }

    static func loadProcessedImage() -> UIImage? {
        guard let data = try? Data(contentsOf: processedImageURL) else {
            return nil
        }
        return UIImage(data: data)
    }

    static func deleteProcessedImage() throws {
        let path = processedImageURL.path
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(at: processedImageURL)
        }
    }

    enum StorageError: Error {
        case failedToEncodeJPEG
    }
}

//
//  PhotoLibrarySaver.swift
//  PrivacyMask
//
//  Created by euwang on 3/7/26.
//


// PhotoLibrarySaver.swift
import UIKit
import Photos

enum PhotoLibrarySaver {
    static func save(_ image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized else {
                completion(.failure(NSError(domain: "Photos", code: 1, userInfo: [NSLocalizedDescriptionKey: "Add-only not authorized"])))
                return
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if let error = error { completion(.failure(error)) }
                else if success { completion(.success(())) }
                else {
                    completion(.failure(NSError(domain: "Photos", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unknown failure"])))
                }
            }
        }
    }
}

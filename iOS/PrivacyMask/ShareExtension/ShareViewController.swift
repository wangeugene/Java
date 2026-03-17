//
//  ShareViewController.swift
//  ShareExtension
//
//  Refactored to use SwiftUI via UIHostingController
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers
import CoreImage
import CoreImage.CIFilterBuiltins

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ EXTENSION APP GROUP PATH:", AppGroupStorage.containerURL.path)

        view.backgroundColor = .systemBackground
        loadSharedImage()
    }

    private func loadSharedImage() {

        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {
            showSwiftUIView(image: nil)
            return
        }

        for provider in attachments {

            print("Provider registered type identifiers:", provider.registeredTypeIdentifiers)

            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { [weak self] item, error in
                    guard let self = self else { return }

                    if let error = error {
                        print("loadItem error:", error)
                    }

                    if let item = item {
                        print("Loaded item type:", type(of: item))
                        print("Loaded item value:", item)
                    } else {
                        print("Loaded item is nil")
                    }

                    var image: UIImage?

                    if let img = item as? UIImage {
                        image = img
                    } else if let url = item as? URL,
                              let data = try? Data(contentsOf: url) {
                        image = UIImage(data: data)
                    } else if let data = item as? Data {
                        image = UIImage(data: data)
                    }

                    if let sourceImage = image {
                        let downscaledImage = ImageProcessor.downscale(sourceImage, maxDimension: 1600)
                        if let pixelated = ImageProcessor.pixelateWeChatRegions(in: downscaledImage) {
                            image = pixelated
                        } else {
                            image = downscaledImage
                        }
                        if let finalImage = image {
                            do {
                                try AppGroupStorage.saveProcessedImage(finalImage)
                            } catch {
                                print("Failed to save processed image:", error)
                            }
                        }
                    }

                    DispatchQueue.main.async {
                        self.showSwiftUIView(image: image)
                    }
                }

                return
            }
        }

        showSwiftUIView(image: nil)
    }

    private func showSwiftUIView(image: UIImage?) {
        let rootView = SharedImageView(image: image) { [weak self] in
            self?.extensionContext?.completeRequest(returningItems: nil)
        }
        let hosting = UIHostingController(rootView: rootView)
        addChild(hosting)
        hosting.view.frame = view.bounds
        hosting.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)
    }
}


//
//  ShareViewController.swift
//  ShareExtension
//
//  Refactored to use SwiftUI via UIHostingController
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {

                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { [weak self] item, error in

                    guard let self = self else { return }

                    var image: UIImage?

                    if let img = item as? UIImage {
                        image = img
                    }

                    if let url = item as? URL,
                       let data = try? Data(contentsOf: url) {
                        image = UIImage(data: data)
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

        let rootView = SharedImageView(image: image)
        let hosting = UIHostingController(rootView: rootView)

        addChild(hosting)
        hosting.view.frame = view.bounds
        hosting.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)
    }
}

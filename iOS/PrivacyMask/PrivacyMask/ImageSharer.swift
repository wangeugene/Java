//
//  ImageSharer.swift
//  PrivacyMask
//
//  Created by euwang on 3/17/26.
//


import UIKit

enum ImageSharer {
    static func share(_ image: UIImage, from viewController: UIViewController) {
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(
                x: viewController.view.bounds.midX,
                y: viewController.view.bounds.midY,
                width: 1,
                height: 1
            )
        }

        viewController.present(activityVC, animated: true)
    }
}
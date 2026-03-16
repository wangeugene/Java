//
//  ImageProcessor.swift
//  PrivacyMask
//
//  Created by euwang on 3/5/26.
//



import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct PixelationRegion {
    let rect: CGRect
    let scale: Float
}

struct WeChatPixelationLayout {
    let headerHeightRatio: CGFloat
    let leftColumnWidthRatio: CGFloat
    let rightColumnWidthRatio: CGFloat
    let contentTopInsetRatio: CGFloat
    let horizontalPaddingRatio: CGFloat

    static let `default` = WeChatPixelationLayout(
        headerHeightRatio: 0.093,
        leftColumnWidthRatio: 0.14,
        rightColumnWidthRatio: 0.14,
        contentTopInsetRatio: 0.1,
        horizontalPaddingRatio: 0.02
    )
}

enum ImageProcessor {
    
    static func pixelateWeChatRegions(
        in image: UIImage,
        layout: WeChatPixelationLayout = .default,
        headerScale: Float = 24,
        sideScale: Float = 24
    ) -> UIImage? {

        let size = image.size
        let width = size.width
        let height = size.height

        let headerHeight = height * layout.headerHeightRatio
        let contentTopInset = height * layout.contentTopInsetRatio
        let sideTop = contentTopInset
        let sideHeight = max(height - contentTopInset, 0)
        let horizontalPadding = width * layout.horizontalPaddingRatio
        let leftWidth = width * layout.leftColumnWidthRatio
        let rightWidth = width * layout.rightColumnWidthRatio
        
        let regions = [
            PixelationRegion(
                rect: weChatConversationTitleRect(in: image),
                scale: headerScale
            ),
            PixelationRegion(
                rect: CGRect(
                    x: horizontalPadding,
                    y: sideTop,
                    width: leftWidth,
                    height: sideHeight
                ),
                scale: sideScale
            ),
            PixelationRegion(
                rect: CGRect(
                    x: width - rightWidth - horizontalPadding,
                    y: sideTop,
                    width: rightWidth,
                    height: sideHeight
                ),
                scale: sideScale
            )
        ]

        return pixelateRegions(in: image, regions: regions)
    }

    static func pixelateRegions(
        in image: UIImage,
        regions: [PixelationRegion]
    ) -> UIImage? {

        guard let baseCGImage = image.cgImage else { return nil }

        let imageSize = CGSize(width: baseCGImage.width, height: baseCGImage.height)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, image.scale)
        defer { UIGraphicsEndImageContext() }

        UIImage(cgImage: baseCGImage, scale: image.scale, orientation: .up)
            .draw(in: CGRect(origin: .zero, size: imageSize))

        for region in regions {
            guard let pixelatedRegionImage = pixelateRegion(
                in: UIImage(cgImage: baseCGImage, scale: image.scale, orientation: .up),
                rect: region.rect,
                scale: region.scale
            ) else {
                continue
            }

            pixelatedRegionImage.draw(in: region.rect)
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func pixelateRegion(in image: UIImage, rect: CGRect, scale: Float = 20) -> UIImage? {

        guard let cgImage = image.cgImage else { return nil }

        let imageRect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        let clippedRect = rect.intersection(imageRect).integral

        guard !clippedRect.isNull, clippedRect.width > 0, clippedRect.height > 0 else {
            return nil
        }

        guard let croppedCGImage = cgImage.cropping(to: clippedRect) else {
            return nil
        }

        let croppedImage = UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: .up)
        return pixelate(image: croppedImage, scale: scale)
    }
    
    static func weChatConversationTitleRect(in image: UIImage) -> CGRect {
        let size = image.size
        return CGRect(
            x: size.width * 0.303,
            y: size.height * 0.064,
            width: size.width * 0.424,
            height: size.height * 0.046
        )
    }

    static func pixelate(
        image: UIImage,
        scale: Float = 20
    ) -> UIImage? {

        guard let ciImage = CIImage(image: image) else { return nil }

        let filter = CIFilter.pixellate()
        filter.inputImage = ciImage
        filter.scale = scale

        let context = CIContext()

        guard
            let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: ciImage.extent)
        else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

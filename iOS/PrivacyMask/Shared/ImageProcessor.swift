//
//  ImageProcessor.swift
//  PrivacyMask
//
//  Created by euwang on 3/5/26.
//


import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

enum ImageProcessor {

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

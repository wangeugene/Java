//
//  SharedImageView.swift
//  PrivacyMask
//
//  Created by euwang on 3/5/26.
//


import SwiftUI

struct SharedImageView: View {

    let image: UIImage?

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView("Loading image...")
            }
        }
        .padding()
    }
}
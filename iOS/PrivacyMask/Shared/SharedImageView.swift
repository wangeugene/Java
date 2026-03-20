//
//  SharedImageView.swift
//  PrivacyMask
//
//  Created by euwang on 3/5/26.
//


import SwiftUI

struct SharedImageView: View {

    let image: UIImage?
    var onSaved: (() -> Void)? = nil
    @State private var saving = false
    @State private var message: String?

    var body: some View {
        VStack {
            if let image = image {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
                Button(saving ? "Saving..." : "Save to Photos") {
                    guard !saving else { return }
                    saving = true
                    PhotoLibrarySaver.save(image) { result in
                        DispatchQueue.main.async {
                            saving = false
                            switch result {
                            case .success:
                                message = "Saved to Photos"
                                onSaved?() // optional: dismiss extension
                            case .failure(let error):
                                message = error.localizedDescription
                            }
                        }
                    }
                }
                .disabled(saving)
                
                Button("Dismiss") { onSaved?() }
                
            } else {
                ProgressView("Loading image...")
            }
        }
        .padding()
    }
}


//
//  ContentView.swift
//  MyCamera
//
//  Created by euwang on 2/27/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var showingCamera = false
    @State private var capturedImage: UIImage?
    @State private var showNoCameraAlert = false

    var body: some View {
        VStack(spacing: 16) {
            if let image = capturedImage {
                VStack(alignment: .leading, spacing: 8) {
                    Text("A man must keep learning to be great")
                        .font(.headline)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 1)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            } else {
                Text("No photo yet")
                    .foregroundStyle(.secondary)
            }

            Button(action: {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showingCamera = true
                } else {
                    showNoCameraAlert = true
                }
            }, label: {
                Label("Open Camera", systemImage: "camera")
                    .font(.title2)
            })
            .buttonStyle(.borderedProminent)

            if showingCamera {
                CustomCameraView { image in
                    capturedImage = image
                    do {
                        let url = try ImageStore.saveJPEG(image)
                        print("Saved image at:", url.path)
                    } catch {
                        print("Failed to save image:", error.localizedDescription)
                    }
                    showingCamera = false
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .alert("Camera Unavailable", isPresented: $showNoCameraAlert) {
            Button("OK", role: .cancel) {}
        }
        message: {
            Text("This device doesn't have a camera. Try running on a real device.")
        }
        .onAppear() {
            print("Camera usage description:", Bundle.main.object(forInfoDictionaryKey: "NSCameraUsageDescription") as? String ?? "Missing")
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI
import AVFoundation
import UIKit
import Combine

// Live camera preview layer in SwiftUI
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
        context.coordinator.previewLayer = layer
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.previewLayer?.frame = uiView.bounds
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}

// Camera controller object
@MainActor final class CameraController: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var photoCaptureContinuation: CheckedContinuation<UIImage?, Never>?
    let objectWillChange = ObservableObjectPublisher()

    override init() {
        super.init()
        configureSession()
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        // Input (back camera)
        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            session.commitConfiguration()
            return
        }
        session.addInput(input)

        // Output
        guard session.canAddOutput(output) else {
            session.commitConfiguration()
            return
        }
        session.addOutput(output)
        session.commitConfiguration()
    }

    func start() {
        guard !session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    func stop() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }

    // Capture photo and return UIImage with async/await
    func capturePhoto() async -> UIImage? {
        await withCheckedContinuation { continuation in
            self.photoCaptureContinuation = continuation
            let settings = AVCapturePhotoSettings()
            output.capturePhoto(with: settings, delegate: self)
        }
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        let image: UIImage?
        if let data = photo.fileDataRepresentation() {
            image = UIImage(data: data)
        } else {
            image = nil
        }
        photoCaptureContinuation?.resume(returning: image)
        photoCaptureContinuation = nil
    }
}

// SwiftUI camera view you can size however you like
struct CustomCameraView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraController()

    var onCapture: (UIImage) -> Void

    var body: some View {
        ZStack {
            CameraPreview(session: camera.session)
                .ignoresSafeArea(edges: .bottom) // remove if you want padding

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        Task {
                            if let image = await camera.capturePhoto() {
                                onCapture(image)
                                dismiss()
                            }
                        }
                    } label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 68, height: 68)
                            .overlay(Circle().stroke(.black.opacity(0.2), lineWidth: 2))
                            .shadow(radius: 3)
                    }
                    Spacer()
                }
                .padding(.bottom, 24)
            }
        }
        .onAppear { camera.start() }
        .onDisappear { camera.stop() }
        // You can constrain the height when presenting inline:
        // .frame(height: 300)
    }
}

import AVFoundation

extension AVVideoComposition {
    /// Async wrapper around AVVideoComposition.videoComposition(with:applyingCIFiltersWithHandler:completionHandler:)
    /// to replace the deprecated init(asset:applyingCIFiltersWithHandler:).
    static func tcvVideoComposition(
        with asset: AVAsset,
        applyingCIFiltersWithHandler applier: @Sendable @escaping (AVAsynchronousCIImageFilteringRequest) -> Void
    ) async throws -> AVVideoComposition {
        try await withCheckedThrowingContinuation { continuation in
            AVVideoComposition.videoComposition(
                with: asset,
                applyingCIFiltersWithHandler: applier,
                completionHandler: { videoComposition, error in
                    if let videoComposition {
                        continuation.resume(returning: videoComposition)
                    } else if let error {
                        continuation.resume(throwing: error)
                    } else {
                        let nsError = NSError(
                            domain: "AVVideoComposition+AsyncCIFilters",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to create AVVideoComposition."]
                        )
                        continuation.resume(throwing: nsError)
                    }
                }
            )
        }
    }
}

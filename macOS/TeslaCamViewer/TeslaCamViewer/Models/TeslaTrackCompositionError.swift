import AVFoundation

enum TeslaTrackCompositionError: LocalizedError {
    case emptyTrack
    case compositionTrackCreationFailed
    case missingVideoTrack(URL)
    case insertionFailed(URL, underlying: Error)

    var errorDescription: String? {
        switch self {
        case .emptyTrack:
            return "The selected camera track does not contain any clips."
        case .compositionTrackCreationFailed:
            return "Failed to create a mutable composition track."
        case .missingVideoTrack(let url):
            return "The clip does not contain a playable video track: \(url.lastPathComponent)"
        case .insertionFailed(let url, let underlying):
            return "Failed to append \(url.lastPathComponent) to the composition: \(underlying.localizedDescription)"
        }
    }
}
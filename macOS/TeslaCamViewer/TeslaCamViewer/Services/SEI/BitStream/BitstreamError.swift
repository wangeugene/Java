//
//  BitstreamError.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/8/26.
//


import Foundation

enum BitstreamError: LocalizedError {
    case invalidSample
    case invalidNALLength
    case truncatedData
    case noVideoTrack
    case assetReaderCreationFailed
    case assetReaderStartFailed

    var errorDescription: String? {
        switch self {
        case .invalidSample:
            return "Invalid encoded video sample."
        case .invalidNALLength:
            return "Invalid NAL unit length."
        case .truncatedData:
            return "Unexpected end of bitstream data."
        case .noVideoTrack:
            return "No video track was found in the input file."
        case .assetReaderCreationFailed:
            return "Failed to create AVAssetReader."
        case .assetReaderStartFailed:
            return "Failed to start reading encoded video samples."
        }
    }
}

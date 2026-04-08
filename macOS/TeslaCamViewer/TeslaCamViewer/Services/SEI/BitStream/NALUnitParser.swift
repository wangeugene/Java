//
//  NALUnitParser.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/8/26.
//

import Foundation

struct NALUnitParser {
    // sample = [length][NAL][length][NAL][length][NAL]...
    func parseNALUnits(from sampleData: Data) throws -> [NALUnit] {
        guard !sampleData.isEmpty else {
            return []
        }

        var nalUnits: [NALUnit] = []
        var offset = 0
        let byteCount = sampleData.count

        while offset + 4 <= byteCount {
            let length = sampleData.withUnsafeBytes { rawBuffer -> Int in
                let base = rawBuffer.baseAddress!.assumingMemoryBound(to: UInt8.self)
                let b0 = Int(base[offset])
                let b1 = Int(base[offset + 1])
                let b2 = Int(base[offset + 2])
                let b3 = Int(base[offset + 3])
                return (b0 << 24) | (b1 << 16) | (b2 << 8) | b3
            }

            offset += 4

            guard length > 0 else {
                continue
            }

            guard offset + length <= byteCount else {
                throw BitstreamError.invalidNALLength
            }

            let payload = sampleData.subdata(in: offset..<(offset + length))
            let type = classifyNALUnitType(from: payload)
            nalUnits.append(NALUnit(type: type, payload: payload))
            offset += length
        }

        if offset != byteCount {
            throw BitstreamError.truncatedData
        }

        return nalUnits
    }
}

private extension NALUnitParser {
    func classifyNALUnitType(from payload: Data) -> NALUnitType {
        guard let firstByte = payload.first else {
            return .other(-1)
        }

        // H.264 NAL unit type is stored in the low 5 bits.
        let h264Type = Int(firstByte & 0x1F)
        if h264Type == 6 {
            return .sei
        }

        // H.265 / HEVC NAL unit type is stored in bits 1...6.
        let h265Type = Int((firstByte >> 1) & 0x3F)
        if h265Type == 39 || h265Type == 40 {
            return .sei
        }

        return .other(h264Type)
    }
}

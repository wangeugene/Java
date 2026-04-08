//
//  BitstreamReader.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/8/26.
//


import Foundation

struct BitstreamReader {
    private let data: Data
    private var offset: Int = 0

    init(data: Data) {
        self.data = data
    }

    mutating func readUInt8() -> UInt8? {
        guard offset < data.count else { return nil }
        let value = data[offset]
        offset += 1
        return value
    }

    mutating func readData(count: Int) -> Data? {
        guard offset + count <= data.count else { return nil }
        let slice = data[offset..<(offset + count)]
        offset += count
        return Data(slice)
    }
}

//
//  TeslaEventJSONLoader.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


//
//  TeslaEventJSONLoader.swift
//  TeslaCamViewer
//

import Foundation

enum TeslaEventJSONLoader {
    static func loadMetadata(from url: URL?) -> TeslaEventMetadata? {
        guard let url else { return nil }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(TeslaEventMetadata.self, from: data)
        } catch {
            print("Failed to parse event.json at \(url.path): \(error)")
            return nil
        }
    }
}

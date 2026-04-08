
import Foundation

protocol TeslaSEIExtracting {
    func extract(from clipURL: URL) async throws -> [TeslaSEISample]
}

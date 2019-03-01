import Foundation

public struct FeesOverviewResponse: Decodable {
    public let fees: [String: [FeeResponse]]
}

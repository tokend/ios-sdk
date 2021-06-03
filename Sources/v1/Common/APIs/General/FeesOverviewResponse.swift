import Foundation

@available(*, deprecated)
public struct FeesOverviewResponse: Decodable {
    public let fees: [String: [FeeResponse]]
}

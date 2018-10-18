import Foundation

public struct OffersOffersRequestParameters {
    /// - Note: `true` for pending investments, because they are always bought by you.
    /// For pending offers to load all offers `isBuy` should be `nil`.
    public let isBuy: Bool?
    public let order: String?
    public let baseAsset: String?
    public let quoteAsset: String?
    /// - Note: `nil` for pending investments, `"0"` for pending offers.
    public let orderBookId: String?
    public let offerId: String?
    public let other: RequestParameters?
    
    public init(
        isBuy: Bool?,
        order: String?,
        baseAsset: String?,
        quoteAsset: String?,
        orderBookId: String?,
        offerId: String?,
        other: RequestParameters? = nil
        ) {
        
        self.isBuy = isBuy
        self.order = order
        self.baseAsset = baseAsset
        self.quoteAsset = quoteAsset
        self.orderBookId = orderBookId
        self.offerId = offerId
        self.other = other
    }
}

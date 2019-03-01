import Foundation

/// Offers request parameters model.
public struct OffersRequestParametersV3 {
    
    // MARK: - Public properties
    
    public let baseBalance: String?
    public let quoteBalance: String?
    public let baseAsset: String?
    public let quoteAsset: String?
    public let owner: String?
    /// - Note: `nil` for pending investments, `"0"` for pending offers.
    public let orderBookId: String?
    public let offerId: String?
    
    public init(
        baseBalance: String?,
        quoteBalance: String?,
        baseAsset: String?,
        quoteAsset: String?,
        owner: String?,
        orderBookId: String?,
        offerId: String?
        ) {
        
        self.baseBalance = baseBalance
        self.quoteBalance = quoteBalance
        self.baseAsset = baseAsset
        self.quoteAsset = quoteAsset
        self.owner = owner
        self.orderBookId = orderBookId
        self.offerId = offerId
    }
}

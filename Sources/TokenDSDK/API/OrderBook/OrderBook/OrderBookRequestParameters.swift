import Foundation

public struct OrderBookRequestParameters: Encodable {
    public let isBuy: Bool?
    public let baseAsset: String
    public let quoteAsset: String
    
    public init(
        isBuy: Bool?,
        baseAsset: String,
        quoteAsset: String
        ) {
        
        self.isBuy = isBuy
        self.baseAsset = baseAsset
        self.quoteAsset = quoteAsset
    }
}

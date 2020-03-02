import Foundation

public struct TradesRequestParameters: Encodable {
    
    public let baseAsset: String
    public let quoteAsset: String
    public let orderBookId: String
    
    public init(
        baseAsset: String,
        quoteAsset: String,
        orderBookId: String
        ) {
        
        self.baseAsset = baseAsset
        self.quoteAsset = quoteAsset
        self.orderBookId = orderBookId
    }
}

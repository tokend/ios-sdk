import Foundation

/// Class provides functionality that allows to build order book requests
public class OrderBookRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let orderBooks: String = "order_books"
    
    public let includeBuyEntries: String = "buy_entries"
    public let includeSellEntries: String = "sell_entries"
    public let includeBaseAsset: String = "base_asset"
    public let includeQuoteAsset: String = "quote_asset"
    public var offersIncludeAll: [String] {
        return [
            self.includeBuyEntries,
            self.includeSellEntries,
            self.includeBaseAsset,
            self.includeQuoteAsset
        ]
    }
    
    // MARK: - Public
    
    /// Builds request to fetch order book data from api
    public func buildOffersRequest(
        baseAsset: String,
        quoteAsset: String,
        orderBookId: String = "0",
        maxEntries: Int,
        include: [String]?
        ) -> JSONAPI.RequestModel {
        
        let id = "\(baseAsset):\(quoteAsset):\(orderBookId)"
        let path = /self.v3/self.orderBooks/id
        
        let queryParameters: RequestQueryParameters = ["max_entries": "\(maxEntries)"]
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryInclude(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                include: include
            )
        )
    }
}

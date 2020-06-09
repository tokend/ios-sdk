import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch order book data
public class OrderBookApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: OrderBookRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = OrderBookRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Returns the list of the placed offers without private details.
    /// - Parameters:
    ///   - baseAsset: Base asset.
    ///   - quoteAsset: Quote asset.
    ///   - orderBookId: Order book id. `0` for secondary market, `sale ID` - otherwise.
    ///   - include: Resource to include.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<OrderBookResource>`.
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestOffers(
        baseAsset: String,
        quoteAsset: String,
        orderBookId: String = "0",
        maxEntries: Int,
        include: [String]? = nil,
        completion: @escaping (_ result: RequestSingleResult<Horizon.OrderBookResource>) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildOffersRequest(
            baseAsset: baseAsset,
            quoteAsset: quoteAsset,
            orderBookId: orderBookId,
            maxEntries: maxEntries,
            include: include
        )
        
        let cancelable = self.requestSingle(
            Horizon.OrderBookResource.self,
            request: request,
            completion: completion
        )
        
        return cancelable
    }
}

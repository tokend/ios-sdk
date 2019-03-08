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
    ///   - orderBookId: Order book id. `0` for secondary market, `sale ID` - otherwise.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<OrderBookEntryResource>`.
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestOffers(
        orderBookId: String,
        filters: OrderBookRequestFiltersV3,
        include: [String]? = nil,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping (_ result: RequestCollectionResult<OrderBookEntryResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildOffersRequest(
            orderBookId: orderBookId,
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                onRequestBuilt?(request)
                
                cancelable.cancelable = self?.requestCollection(
                    OrderBookEntryResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
}

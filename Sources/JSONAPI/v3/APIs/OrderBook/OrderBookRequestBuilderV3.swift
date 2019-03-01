import Foundation

/// Class provides functionality that allows to build order book requests
public class OrderBookRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let orderBook = "order_book"
    
    // MARK: - Public
    
    /// Builds request to fetch order book data from api
    public func buildOffersRequest(
        orderBookId: String,
        filters: OrderBookRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.orderBook/orderBookId
        
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch offers
public class OffersRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let offers = "offers"
    
    // MARK: - Public
    
    /// Builds request to fetch offers.
    /// - Parameters:
    ///   - parameters: Parameters of the offer.
    ///   - other: Other query parameters.
    ///   - pagination: Pagination option.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildOffersRequest(
        filters: OffersRequestFilterV3,
        parameters: OffersRequestParametersV3?,
        other: RequestQueryParameters?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.offers
        
        let queryFilters = self.buildFilterQueryItems(filters.filterItems)
        
        var queryParameters = RequestQueryParameters()
        
        if let baseBalance = parameters?.baseBalance {
            queryParameters["base_balance"] = baseBalance
        }
        
        if let quoteBalance = parameters?.quoteBalance {
            queryParameters["quote_balance"] = quoteBalance
        }
        
        if let baseAsset = parameters?.baseAsset {
            queryParameters["base_asset"] = baseAsset
        }
        
        if let quoteAsset = parameters?.quoteAsset {
            queryParameters["quote_asset"] = quoteAsset
        }
        
        if let owner = parameters?.owner {
            queryParameters["owner"] = owner
        }
        
        if let orderBookId = parameters?.orderBookId {
            queryParameters["order_book_id"] = orderBookId
        }
        
        if let offerId = parameters?.offerId {
            queryParameters["offer_id"] = offerId
        }
        
        if let other = other {
            queryParameters = queryParameters.merging(other, uniquingKeysWith: { (value1, _) -> String in
                return value1
            })
        }
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryPagination(
                path: path,
                method: .get,
                queryParameters: queryFilters,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to fetch offer by Id.
    /// - Parameters:
    ///   - offerId: Offer Id.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildOfferByIdRequest(
        offerId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.offers/offerId
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

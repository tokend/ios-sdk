import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch order books
public class OrderBookRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch order book data from api
    /// - Parameters:
    ///   - parameters: Order book request parameters.
    /// - Returns: `OrderBookRequest`
    public func buildOrderBookRequest(
        parameters: OrderBookRequestParameters?,
        orderDescending: Bool = true,
        limit: Int?,
        cursor: String?
        ) -> OrderBookRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("order_book")
        
        let parametersEncoding: RequestParametersEncoding = .url
        var parametersDict: RequestParameters = self.requestParametersToDictionary(parameters) ?? [:]
        
        if orderDescending {
            parametersDict["order"] = "desc"
        } else {
            parametersDict["order"] = "asc"
        }
        
        if let limit = limit {
            parametersDict["limit"] = limit
        }
        
        if let cursor = cursor {
            parametersDict["cursor"] = cursor
        }
        
        let request = OrderBookRequest(
            url: url,
            method: .get,
            parameters: parametersDict,
            parametersEncoding: parametersEncoding
        )
        
        return request
    }
    
    /// Builds request to fetch trades data from api
    /// - Parameters:
    ///   - parameters: Trades request parameters.
    /// - Returns: `OrderBookRequest`
    public func buildTradesRequest(
        parameters: TradesRequestParameters?,
        orderDescending: Bool = true,
        limit: Int?,
        cursor: String?
        ) -> TradesRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("trades")
        
        let parametersEncoding: RequestParametersEncoding = .url
        var parametersDict: RequestParameters = self.requestParametersToDictionary(parameters) ?? [:]
        
        if orderDescending {
            parametersDict["order"] = "desc"
        } else {
            parametersDict["order"] = "asc"
        }
        
        if let limit = limit {
            parametersDict["limit"] = limit
        }
        
        if let cursor = cursor {
            parametersDict["cursor"] = cursor
        }
        
        let request = TradesRequest(
            url: url,
            method: .get,
            parameters: parametersDict,
            parametersEncoding: parametersEncoding
        )
        
        return request
    }
}

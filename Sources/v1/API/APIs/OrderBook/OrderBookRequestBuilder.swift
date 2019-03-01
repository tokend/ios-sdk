import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch order books
public class OrderBookRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch account data from api
    /// - Parameters:
    ///   - parameters: Order book parameters.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `OrderBookRequest` or nil.
    public func buildOrderBookRequest(
        parameters: OrderBookRequestParameters?,
        sendDate: Date,
        completion: @escaping (OrderBookRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("order_book")
        
        let parametersEncoding: RequestParametersEncoding = .url
        let parametersDict: RequestParameters = self.requestParametersToDictionary(parameters) ?? [:]
        
        self.buildRequestParametersSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            parameters: parametersDict,
            parametersEncoding: parametersEncoding,
            completion: completion
        )
    }
}

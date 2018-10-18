import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch order books
public class OrderBookRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch account data from api
    /// - Parameters:
    ///   - parameters: Order book parameters.
    ///   - sendDate: Send time of request.
    /// - Returns: `OrderBookRequest`
    public func buildOrderBookRequest(
        parameters: OrderBookRequestParameters?,
        sendDate: Date
        ) -> OrderBookRequest {
        
        let url = self.apiConfiguration.urlString.addPath("order_book")
        
        let parametersEncoding: RequestParametersEncoding = .urlEncoding
        let parametersDict: RequestParameters = self.requestParametersToDictionary(parameters) ?? [:]
        
        let requestSignModel = RequestSignParametersModel(
            urlString: url,
            parameters: parametersDict,
            parametersEncoding: parametersEncoding
        )
        let signedHeaders = self.requestSigner.sign(
            request: requestSignModel,
            sendDate: sendDate
        )
        
        let request = OrderBookRequest(
            url: url,
            method: .get,
            parameters: parametersDict.isEmpty ? nil : parametersDict,
            parametersEncoding: parametersEncoding,
            signedHeaders: signedHeaders
        )
        
        return request
    }
}

import Foundation

/// Class provides functionality that allows to fetch order books
@available(*, deprecated, message: "Use OrderBookApiV3")
public class OrderBookApi: BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: OrderBookRequestBuilder
    
    // MARK: -
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = OrderBookRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in completion block of `OrderBookApi.requestOrderBook(...)`
    public enum RequestTradesResult {
        
        /// Case of successful response with list of `OrderBookResponse`
        case success(trades: [TradeResponse])
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to fetch trades data.
    /// The result of request will be fetched in `completion` block as `OrderBookApi.RequestTradesResult`
    /// - Parameters:
    ///   - parameters: Trades parameters.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `OrderBookApi.RequestTradesResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestTrades(
        parameters: TradesRequestParameters?,
        orderDescending: Bool = true,
        limit: Int?,
        cursor: String?,
        completion: @escaping (_ result: RequestTradesResult) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildTradesRequest(
            parameters: parameters,
            orderDescending: orderDescending,
            limit: limit,
            cursor: cursor
        )
        let cancelable = self.network.responseObject(
            RequestResultPage<OrderBookEmbedded<TradeResponse>>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                switch result {
                    
                case .success(let object):
                    completion(.success(trades: object.embedded.records))
                    
                case .failure(let errors):
                    completion(.failure(errors))
                }
        })
        
        return cancelable
    }
}

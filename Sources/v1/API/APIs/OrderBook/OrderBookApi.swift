import Foundation

/// Class provides functionality that allows to fetch order books
public class OrderBookApi: BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: OrderBookRequestBuilder
    
    // MARK: -
    
    public override init(apiStack: BaseApiStack) {
        self.requestBuilder = OrderBookRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    /// Model that will be fetched in completion block of `OrderBookApi.requestOrderBook(...)`
    public enum RequestOrderBookResult {
        
        /// Case of successful response with list of `OrderBookResponse`
        case success(orderBook: [OrderBookResponse])
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to fetch order book data.
    /// The result of request will be fetched in `completion` block as `OrderBookApi.RequestOrderBookResult`
    /// - Parameters:
    ///   - parameters: Order book parameters.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `OrderBookApi.RequestOrderBookResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestOrderBook(
        parameters: OrderBookRequestParameters?,
        orderDescending: Bool = true,
        limit: Int?,
        cursor: String?,
        completion: @escaping (_ result: RequestOrderBookResult) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildOrderBookRequest(
            parameters: parameters,
            orderDescending: orderDescending,
            limit: limit,
            cursor: cursor
        )
        let cancelable = self.network.responseObject(
            RequestResultPage<OrderBookEmbedded<OrderBookResponse>>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                switch result {
                    
                case .success(let object):
                    completion(.success(orderBook: object.embedded.records))
                    
                case .failure(let errors):
                    completion(.failure(errors))
                }
        })
        
        return cancelable
    }
    
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

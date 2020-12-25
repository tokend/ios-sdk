import Foundation

/// Class provides functionality that allows to fetch charts
public class ChartsApi: BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: ChartsRequestBuilder
    
    // MARK: -
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = ChartsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    /// Model that will be fetched in completion block of `ChartsApi.requestCharts(...)`
    public enum ChartsResult {
        
        /// Case of successful response with `ChartsResponse` model
        case success(charts: ChartsResponse)
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to get balances for according account from api.
    /// The result of request will be fetched in `completion` block as `ChartsApi.ChartsResult`
    /// - Parameters:
    ///   - asset: The code of the asset for which charts are going to be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `ChartsApi.ChartsResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestCharts(
        asset: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: ChartsResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildChartsRequest(
            asset: asset,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    ChartsResponse.self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    completion: { (result) in
                        switch result {
                            
                        case .success(let object):
                            completion(.success(charts: object))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
}

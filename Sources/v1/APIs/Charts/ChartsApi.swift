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
}

// MARK: - Public methods

public extension ChartsApi {
    
    /// Method sends request to get balances for according account from api.
    /// The result of request will be fetched in `completion` block as `Swift.Result<ChartsResponse, Swift.Error>`
    /// - Parameters:
    ///   - asset: The code of the asset for which charts are going to be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Swift.Result<ChartsResponse, Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func getCharts(
        asset: String,
        sendDate: Date = Date(),
        completion: @escaping (Swift.Result<ChartsResponse, Swift.Error>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildChartsRequest(
            asset: asset,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
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
                            completion(.success(object))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
}

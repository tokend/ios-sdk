import Foundation

/// Class provides functionality that allows to fetch assets
public class AssetsApi: BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: AssetsRequestBuilder
    
    // MARK: -
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = AssetsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in completion block of `AssetsApi.requestAssets(...)`
    public enum RequestAssetsResult {
        
        /// Case of successful response with list of `Asset`
        case success(assets: [Asset])
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to get assets for according account from api.
    /// The result of request will be fetched in `completion` block as `AssetsApi.RequestAssetsResult`
    /// - Parameters:
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `AssetsApi.RequestAssetsResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAssets(
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestAssetsResult) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildAssetsRequest(
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    [Asset].self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    completion: { result in
                        switch result {
                            
                        case .success(let objects):
                            completion(.success(assets: objects))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
}

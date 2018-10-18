import Foundation

/// Class provides functionality that allows to fetch asset pairs
public class AssetPairsApi: BaseApi {
    let requestBuilder: AssetPairsRequestBuilder
    
    public override init(apiStack: BaseApiStack) {
        self.requestBuilder = AssetPairsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in completion block of `AssetPairsApi.requestAssetPairs(...)`
    public enum RequestAssetPairsResult {
        
        /// Case of successful response with list of `AssetPair`
        case success(assetPairs: [AssetPair])
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to get asset pairs for according account from api.
    /// The result of request will be fetched in `completion` block as `AssetPairsApi.RequestAssetPairsResult`
    /// - Parameters:
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `AssetPairsApi.RequestAssetPairsResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func requestAssetPairs(
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestAssetPairsResult) -> Void
        ) -> CancellableToken {
        
        let request = self.requestBuilder.buildAssetPairsRequest(sendDate: sendDate)
        
        return self.network.responseObject(
            [AssetPair].self,
            url: request.url,
            method: request.method,
            headers: request.signedHeaders,
            completion: { (result) in
                switch result {
                    
                case .success(let objects):
                    completion(.success(assetPairs: objects))
                    
                case .failure(let errors):
                    completion(.failure(errors))
                }
        })
    }
}

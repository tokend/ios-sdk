import Foundation

/// Class provides functionality that allows to fetch blobs
public class BlobsApi: BaseApi {
    
    let requestBuilder: BlobsRequestBuilder
    
    public override init(apiStack: BaseApiStack) {
        self.requestBuilder = BlobsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in `completion` block of `BlobsApi.requestBlob(...) `
    public enum GetBlobResult {
        
        /// Case of succesful response from api with `BlobResponse` model
        case success(blob: BlobResponse)
        
        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to get blob from api.
    /// The result of request will be fetched in `completion` block as `BlobsApi.GetBlobResult`
    /// - Parameters:
    ///   - blobId: Blob Id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `BlobsApi.GetBlobResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestBlob(
        blobId: String,
        completion: @escaping (_ result: GetBlobResult) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetBlobRequest(
            blobId: blobId,
            sendDate: Date(),
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    ApiDataResponse<BlobResponse>.self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                            
                        case .success(let object):
                            completion(.success(blob: object.data))
                        }
                })
        })
        
        return cancelable
    }
}

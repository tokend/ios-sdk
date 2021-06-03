import Foundation

extension BlobsApi {

    /// Model that will be fetched in `completion` block of `postBlob(...)`
    @available(*, deprecated)
    enum PostBlobResult {

        /// Case of succesful response from api
        case success(BlobResponse)

        /// Case of failed response from api with `ApiErrors` model
        case failure(Swift.Error)
    }
    /// Method sends request to create blob.
    /// - Parameters:
    ///   - type: Blob type.
    ///   - value: Blob value.
    ///   - ownerAccountId: Owner account id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `BlobsApi.PostBlobResult`
    /// - Returns: `Cancelable`
    @discardableResult
    @available(*, deprecated, message: "Use postBlob instead")
    func postBlob(
        type: String,
        value: String,
        ownerAccountId: String,
        completion: @escaping (PostBlobResult) -> Void
    ) -> Cancelable {
        
        return postBlob(
            type: type,
            value: value,
            ownerAccountId: ownerAccountId,
            completion: { (result: Swift.Result<BlobResponse, Swift.Error>) in
                
                switch result {
                
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let response):
                    completion(.success(response))
                }
            }
        )
    }
    
    /// Model that will be fetched in `completion` block of `BlobsApi.requestBlob(...)`
    @available(*, deprecated)
    enum GetBlobResult {
        
        /// Case of succesful response from api with `BlobResponse` model
        case success(blob: BlobResponse)
        
        /// Case of failed response from api with `ApiErrors` model
        case failure(Swift.Error)
    }
    /// Method sends request to get blob from api.
    /// The result of request will be fetched in `completion` block as `BlobsApi.GetBlobResult`
    /// - Parameters:
    ///   - blobId: Blob Id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `BlobsApi.GetBlobResult`
    /// - Returns: `Cancelable`
    @discardableResult
    @available(*, deprecated, message: "Use getBlob instead")
    func requestBlob(
        blobId: String,
        completion: @escaping (_ result: GetBlobResult) -> Void
        ) -> Cancelable {
        
        return getBlob(
            blobId: blobId,
            completion: { (result: Swift.Result<BlobResponse, Swift.Error>) in
                
                switch result {
                
                case .failure(let error):
                    completion(.failure(error))
                
                case .success(let response):
                    completion(.success(blob: response))
                }
            }
        )
    }
}

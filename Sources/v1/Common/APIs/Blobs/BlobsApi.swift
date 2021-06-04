import Foundation

/// Class provides functionality that allows to fetch blobs
public class BlobsApi: BaseApi {
    
    // MARK: - Internal properties
    
    internal let requestBuilder: BlobsRequestBuilder
    
    // MARK: -
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = BlobsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
}
 
// MARK: - Public methods

public extension BlobsApi {
    
    /// Method sends request to get blob from api.
    /// The result of request will be fetched in `completion` block as `BlobsApi.GetBlobResult`
    /// - Parameters:
    ///   - blobId: Blob Id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `BlobsApi.GetBlobResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func getBlob(
        blobId: String,
        completion: @escaping (Swift.Result<BlobResponse, Swift.Error>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetBlobRequest(
            blobId: blobId,
            sendDate: Date(),
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
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
                            completion(.success(object.data))
                        }
                })
        })
        
        return cancelable
    }
    
    /// Method sends request to create blob.
    /// - Parameters:
    ///   - type: Blob type.
    ///   - value: Blob value.
    ///   - ownerAccountId: Owner account id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Swift.Result<BlobResponse, Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func postBlob(
        type: String,
        value: String,
        ownerAccountId: String,
        completion: @escaping (Swift.Result<BlobResponse, Swift.Error>) -> Void
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        let body: ApiDataRequest<PostBlobRequestModel, Empty> = .init(
            data: .init(
                type: type,
                attributes: .init(
                    value: value
                ),
                relationships: .init(
                    owner: .init(
                        data: .init(
                            id: ownerAccountId
                        )
                    )
                )
            )
        )
        
        let encodedRequest: Data
        do {
            encodedRequest = try body.encode()
        } catch {
            completion(.failure(error))
            return network.getEmptyCancelable()
        }

        self.requestBuilder.buildPostBlobRequest(
            body: encodedRequest,
            sendDate: Date(),
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.network.responseDataObject(
                    ApiDataResponse<BlobResponse>.self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    bodyData: request.requestData,
                    completion: { (result) in

                        switch result {

                        case .failure(let errors):
                            completion(.failure(errors))

                        case .success(let response):
                            completion(.success(response.data))
                        }
                })
        })

        return cancelable
    }
}

import Foundation

extension AccountsApi {

    /// Model that will be fetched in `completion` block of `requestBlob(...)`
    @available(*, deprecated, message: "Use BlobsAPI")
    public enum GetBlobResult {

        /// Case of succesful response from api with `BlobResponse` model
        case success(blob: BlobResponse)

        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
    }

    /// Method sends request to request blob.
    /// The result of request will be fetched in `completion` block as `GetBlobResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which blob should be fetched.
    ///   - blobId: Identifier of blob to be fetched.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GetBlobResult`
    /// - Returns: `Cancelable`
    @discardableResult
    @available(*, deprecated, message: "Use BlobsAPI")
    public func requestBlob(
        accountId: String,
        blobId: String,
        completion: @escaping (_ result: GetBlobResult) -> Void
        ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildGetBlobRequest(
            accountId: accountId,
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

    /// Model that will be fetched in `completion` block of `uploadBlob(...)`
    @available(*, deprecated, message: "Use BlobsAPI")
    public enum UploadBlobResult {

        /// Case of succesful response from api
        case success(UploadBlobResponse)

        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
    }

    /// Method sends request to upload blob.
    /// The result of request will be fetched in `completion` block as `UploadBlobResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which blob should be uploaded.
    ///   - blob: Blob object.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `UploadBlobResult`
    /// - Returns: `Cancelable`
    @discardableResult
    @available(*, deprecated, message: "Use BlobsAPI")
    public func uploadBlob(
        accountId: String,
        blob: UploadBlobModel,
        completion: @escaping (_ result: UploadBlobResult) -> Void
        ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildUploadBlobRequest(
            accountId: accountId,
            blob: blob,
            sendDate: Date(),
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.network.responseDataObject(
                    ApiDataResponse<UploadBlobResponse>.self,
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

import Foundation

extension AccountsRequestBuilder {

    private var accounts: String { "accounts" }
    @available(*, deprecated, message: "Use BlobsAPI")
    private var blobs: String { "blobs" }

    /// Builds request to fetch blob
    /// - Parameters:
    ///   - accountId: Account Id.
    ///   - blobId: Blob Id.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `GetBlobRequest` or nil.
    @available(*, deprecated, message: "Use BlobsAPI")
    public func buildGetBlobRequest(
        accountId: String,
        blobId: String,
        sendDate: Date,
        completion: @escaping (GetBlobRequest?) -> Void
        ) {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.accounts).addPath(accountId).addPath(self.blobs).addPath(blobId)

        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }

    /// Builds request to upload blob.
    /// - Parameters:
    ///   - accountId: Account Id.
    ///   - blob: Blob object.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `UploadBlobRequest` or nil.
    @available(*, deprecated, message: "Use BlobsAPI")
    public func buildUploadBlobRequest(
        accountId: String,
        blob: UploadBlobModel,
        sendDate: Date,
        completion: @escaping (UploadBlobRequest?) -> Void
        ) {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.accounts).addPath(accountId).addPath(self.blobs)

        let requestJSON = blob.requestJSON()
        guard let data = try? JSONSerialization.data(withJSONObject: requestJSON, options: []) else {
            completion(nil)
            return
        }

        self.buildRequestDataSigned(
            baseUrl: baseUrl,
            url: url,
            method: .post,
            requestData: data,
            sendDate: sendDate,
            completion: completion
        )
    }
}

import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch blobs
public class BlobsRequestBuilder: BaseApiRequestBuilder {
    
    private let blobs: String = "blobs"
    
    // MARK: - Public
    
    /// Builds request to fetch blob
    /// - Parameters:
    ///   - blobId: Blob Id.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `GetBlobRequest` or nil.
    public func buildGetBlobRequest(
        blobId: String,
        sendDate: Date,
        completion: @escaping (GetBlobRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.blobs).addPath(blobId)
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }

    /// Builds request to post blob
    /// - Parameters:
    ///   - body: Blob data.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `PostBlobRequest` or nil.
    public func buildPostBlobRequest(
        body: Data,
        sendDate: Date,
        completion: @escaping (PostBlobRequest?) -> Void
    ) {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.blobs)

        self.buildRequestDataSigned(
            baseUrl: baseUrl,
            url: url,
            method: .post,
            requestData: body,
            sendDate: sendDate,
            completion: completion
        )
    }
}

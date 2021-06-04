import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch blobs
public class BlobsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Private properties
    
    private let blobs: String = "blobs"
    
}

// MARK: - Public methods
 
public extension BlobsRequestBuilder {
    
    /// Builds request to get blob.
    /// - Parameters:
    ///   - blobId: Blob Id.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `GetBlobRequest` or nil.
    func buildGetBlobRequest(
        blobId: String,
        sendDate: Date,
        completion: @escaping (RequestSigned?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.blobs/blobId
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }

    /// Builds request to create blob.
    /// - Parameters:
    ///   - body: Blob data.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `PostBlobRequest` or nil.
    func buildPostBlobRequest(
        body: Data,
        sendDate: Date,
        completion: @escaping (RequestDataSigned?) -> Void
    ) {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.blobs

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

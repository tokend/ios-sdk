import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch and upload documents.
public class DocumentsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Internal properties
    
    internal let accounts: String = "accounts"
    internal let documents: String = "documents"
    
}
    
// MARK: - Public methods

public extension DocumentsRequestBuilder {
    
    /// Builds request to get upload policy.
    /// - Parameters:
    ///   - body: Blob data.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `RequestDataSigned` or nil.
    func buildGetUploadPolicyRequest(
        body: Data,
        sendDate: Date = Date(),
        completion: @escaping (RequestDataSigned?) -> Void
    ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.documents
        
        self.buildRequestDataSigned(
            baseUrl: baseUrl,
            url: url,
            method: .post,
            requestData: body,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to get document url.
    /// - Parameters:
    ///   - documentId: Document Id.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `RequestSigned` or nil.
    func buildGetDocumentURLRequest(
        documentId: String,
        sendDate: Date = Date(),
        completion: @escaping (RequestSigned?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.documents/documentId
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
}

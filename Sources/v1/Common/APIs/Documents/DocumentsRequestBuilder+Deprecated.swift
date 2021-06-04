import Foundation

public extension DocumentsRequestBuilder {
    
    /// Builds request to request upload policy.
    /// - Parameters:
    ///   - accountId: Account Id.
    ///   - policyType: Policy type. See possible values in `UploadPolicy.Type`.
    ///   - contentType: Content type. See possible values in `UploadPolicy.Content`.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `RequestDataSigned` or nil.
    @available(*, deprecated, message: "Use buildGetUploadPolicyRequest")
    func buildGetUploadPolicyRequest(
        accountId: String,
        policyType: String,
        contentType: String,
        sendDate: Date = Date(),
        completion: @escaping (RequestDataSigned?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.accounts/accountId/self.documents
        
        let request = GetUploadPolicyRequest(policyType: policyType, contentType: contentType)
        
        let requestData = ApiDataRequest<GetUploadPolicyRequest, Empty>(data: request)
        guard let requestDataEncoded = try? requestData.encode() else {
            completion(nil)
            return
        }
        
        self.buildRequestDataSigned(
            baseUrl: baseUrl,
            url: url,
            method: .post,
            requestData: requestDataEncoded,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to fetch document url.
    /// - Parameters:
    ///   - accountId: Account Id.
    ///   - documentId: Document Id.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `RequestSigned` or nil.
    @available(*, deprecated, message: "Use buildGetDocumentURLRequest instead")
    func buildGetDocumentURLRequest(
        accountId: String,
        documentId: String,
        sendDate: Date = Date(),
        completion: @escaping (RequestSigned?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.accounts/accountId/self.documents/documentId
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
}

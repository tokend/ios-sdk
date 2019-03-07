import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch and upload documents
public class DocumentsRequestBuilder: BaseApiRequestBuilder {
    
    private let accounts: String = "accounts"
    private let documents: String = "documents"
    
    // MARK: - Public
    
    /// Builds request to request upload policy
    /// - Parameters:
    ///   - accountId: Account Id.
    ///   - policyType: Policy type. See possible values in `UploadPolicy.Type`.
    ///   - contentType: Content type. See possible values in `UploadPolicy.Content`.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `RequestDataSigned` or nil.
    public func buildGetUploadPolicyRequest(
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
}

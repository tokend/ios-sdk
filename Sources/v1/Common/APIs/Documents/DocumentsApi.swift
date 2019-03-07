import Foundation

public class DocumentsApi: BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: DocumentsRequestBuilder
    
    // MARK: -
    
    public override init(apiStack: BaseApiStack) {
        self.requestBuilder = DocumentsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    public enum GetUploadPolicyResult {
        
        case failure(ApiErrors)
        
        case success(GetUploadPolicyResponse)
    }
    
    /// Requests upload policy
    /// - Parameters:
    ///   - accountId: Account Id.
    ///   - policyType: Policy type. See possible values in `UploadPolicy.Type`.
    ///   - contentType: Content type. See possible values in `UploadPolicy.Content`.
    ///   - completion: Returns `GetUploadPolicyResult` or nil.
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestUploadPolicy(
        accountId: String,
        policyType: String,
        contentType: String,
        completion: @escaping (_ result: GetUploadPolicyResult) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetUploadPolicyRequest(
            accountId: accountId,
            policyType: policyType,
            contentType: contentType,
            completion: { (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancellable.cancelable = self.network.responseDataObject(
                    ApiDataResponse<GetUploadPolicyResponse>.self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    bodyData: request.requestData,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                            
                        case .success(let object):
                            completion(.success(object.data))
                        }
                })
        })
        
        return cancellable
    }
    
    public func uploadDocument(
        uploadPolicy: GetUploadPolicyResponse,
        uploadOption: DocumentUploadOption,
        completion: @escaping (_ result: ResponseMultiPartFormDataResult) -> Void
        ) -> Cancelable {
        
        return self.network.uploadMultiPartFormData(
            url: uploadPolicy.url,
            formData: uploadPolicy.attributes,
            uploadOption: uploadOption,
            completion: completion
        )
    }
}

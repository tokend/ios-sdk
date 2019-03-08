import Foundation

/// Class provides functionality that allows to fetch documents.
public class DocumentsApi: BaseApi {
    
    // MARK: - Public properties
    
    public static let maxRecommendedDocumentSize: Int = 5 * 1024 * 1024 // bytes
    
    public let requestBuilder: DocumentsRequestBuilder
    
    // MARK: -
    
    public override init(apiStack: BaseApiStack) {
        self.requestBuilder = DocumentsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in `completion` block of `DocumentsApi.requestUploadPolicy(...)`
    public enum GetUploadPolicyResult {
        
        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
        
        /// Case of succesful response from api with `GetUploadPolicyResponse` model
        case success(GetUploadPolicyResponse)
    }
    
    /// Requests upload policy
    /// - Parameters:
    ///   - accountId: Account Id.
    ///   - policyType: Policy type. See possible values in `UploadPolicy.Type`.
    ///   - contentType: Content type. See possible values in `UploadPolicy.Content`.
    ///   - completion: Returns `GetUploadPolicyResult`.
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
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancellable.cancelable = self?.network.responseDataObject(
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
    
    /// Uploads document for given upload policy with upload option.
    /// - Parameters:
    ///   - uploadPolicy: Upload policy.
    ///   - uploadOption: Upload option.
    ///   - completion: Returns `ResponseMultiPartFormDataResult`.
    /// - Returns: `Cancelable`
    public func uploadDocument(
        uploadPolicy: GetUploadPolicyResponse,
        uploadOption: DocumentUploadOption,
        completion: @escaping (ResponseMultiPartFormDataResult) -> Void
        ) -> Cancelable {
        
        return self.network.uploadMultiPartFormData(
            url: uploadPolicy.url,
            formData: uploadPolicy.attributes,
            uploadOption: uploadOption,
            completion: completion
        )
    }
    
    /// Model that will be fetched in `completion` block of `DocumentsApi.requestDocumentURL(...)`
    public enum GetDocumentURLResult {
        
        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
        
        /// Case of succesful response from api with `GetDocumentUrlResponse` model
        case success(GetDocumentUrlResponse)
    }
    
    /// Requests document url.
    /// - Parameters:
    ///   - accountId: Account Id.
    ///   - documentId: Document Id.
    ///   - completion: Returns `GetDocumentURLResult`.
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestDocumentURL(
        accountId: String,
        documentId: String,
        completion: @escaping(GetDocumentURLResult) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetDocumentURLRequest(
            accountId: accountId,
            documentId: documentId,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    ApiDataResponse<GetDocumentUrlResponse>.self,
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
}

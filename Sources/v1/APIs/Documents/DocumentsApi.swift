import Foundation

/// Class provides functionality that allows to fetch documents.
public class DocumentsApi: BaseApi {
    
    // MARK: - Public properties
    
    public static let maxRecommendedDocumentSize: Int = 5 * 1024 * 1024 // bytes
    
    // MARK: - Internal properties
    
    internal let requestBuilder: DocumentsRequestBuilder
    
    // MARK: -
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = DocumentsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
}
    
// MARK: - Public methods

public extension DocumentsApi {
    
    /// Requests upload policy.
    /// - Parameters:
    ///   - type: Document policy type. See possible values in `UploadPolicy.PolicyType`.
    ///   - contentType: Content type. See possible values in `UploadPolicy.ContentType`.
    ///   - ownerAccountId: Owner account Id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Swift.Result<GetUploadPolicyResponseModel, Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func getUploadPolicy(
        type: String,
        contentType: String,
        ownerAccountId: String,
        completion: @escaping (Swift.Result<GetUploadPolicyResponse, Swift.Error>) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let body: ApiDataRequest<GetUploadPolicyRequestModel, Empty> = .init(
            data: .init(
                type: type,
                attributes: .init(
                    contentType: contentType
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
        
        self.requestBuilder.buildGetUploadPolicyRequest(
            body: encodedRequest,
            sendDate: Date(),
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseDataObject(
                    ApiDataResponse<GetUploadPolicyResponse>.self,
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
            }
        )
        
        return cancelable
    }
    
    /// Uploads document for given upload policy with upload option.
    /// - Parameters:
    ///   - uploadPolicy: Upload policy.
    ///   - uploadOption: Upload option.
    ///   - completion: Returns `ResponseMultiPartFormDataResult`.
    /// - Returns: `Cancelable`
    func uploadDocument(
        uploadPolicy: GetUploadPolicyResponse,
        uploadOption: DocumentUploadOption,
        completion: @escaping (ResponseMultiPartFormDataResult) -> Void
        ) -> Cancelable {
        
        return self.network.uploadMultiPartFormData(
            url: uploadPolicy.attributes.url,
            formData: uploadPolicy.attributesJSON,
            uploadOption: uploadOption,
            completion: completion
        )
    }
    
    /// Requests document url.
    /// - Parameters:
    ///   - documentId: Document Id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Swift.Result<GetDocumentUrlResponse, Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func getDocumentURL(
        documentId: String,
        completion: @escaping(Swift.Result<GetDocumentUrlResponse, Swift.Error>) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetDocumentURLRequest(
            documentId: documentId,
            sendDate: Date(),
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
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
            }
        )
        
        return cancelable
    }
}

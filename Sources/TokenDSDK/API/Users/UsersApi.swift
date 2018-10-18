import Foundation

/// Class provides functionality that allows to fetch user's data
public class UsersApi {
    
    // MARK: - Public properties
    
    public let apiConfiguration: ApiConfiguration
    public let requestBuilder: UsersRequestBuilder
    public let network: Network
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        requestSigner: RequestSignerProtocol
        ) {
        self.apiConfiguration = apiConfiguration
        self.requestBuilder = UsersRequestBuilder(
            apiConfiguration: apiConfiguration,
            requestSigner: requestSigner
        )
        self.network = Network(userAgent: apiConfiguration.userAgent)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in completion block of `UsersApi.getUser(...)`
    public enum GetUserResult {
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
        
        /// Case of successful response with list of `GetUserResponse`
        case success(GetUserResponse)
    }
    
    /// Method sends request to get user for according account.
    /// The result of request will be fetched in `completion` block as `UsersApi.GetUserResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which user will be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `UsersApi.GetUserResult`
    public func getUser(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: GetUserResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildGetUserRequest(accountId: accountId, sendDate: sendDate)
        
        self.network.responseObject(
            ApiDataResponse<GetUserResponse>.self,
            url: request.url,
            method: request.method,
            headers: request.signedHeaders,
            completion: { result in
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors))
                    
                case .success(let object):
                    completion(.success(object.data))
                }
        })
    }
    
    /// Model that will be fetched in completion block of `UsersApi.createUser(...)`
    public enum CreateUserResult {
        /// Errors that are able to be fetched while trying create user
        public enum CreateUserError: Swift.Error, LocalizedError {
            case modelEncodingFailed
            case requestError(ApiErrors)
            
            // MARK: - LocalizedError
            
            public var errorDescription: String? {
                switch self {
                case .modelEncodingFailed:
                    return "Model encoding failed"
                case .requestError(let errors):
                    return errors.localizedDescription
                }
            }
        }
        
        /// Case of failed response with `CreateUserError` model
        case failure(CreateUserError)
        
        /// Case when user is successfully created
        case success
    }
    
    /// Method sends request to create user for according account.
    /// The result of request will be fetched in `completion` block as `UsersApi.CreateUserResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which user will be created.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `UsersApi.CreateUserResult`
    public func createUser(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: CreateUserResult) -> Void
        ) {
        
        guard let request = try? self.requestBuilder.buildCreateUserRequest(
            accountId: accountId,
            sendDate: sendDate) else {
                completion(.failure(.modelEncodingFailed))
                return
        }
        
        self.network.responseDataEmpty(
            url: request.url,
            method: request.method,
            headers: request.signedHeaders,
            bodyData: request.requestData,
            completion: { result in
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(.requestError(errors)))
                    
                case .success:
                    completion(.success)
                }
        })
    }
    
    /// Model that will be fetched in completion block of `UsersApi.getBlob(...)`
    public enum GetBlobResult<BlobType: Decodable> {
        
        /// Case of failed result with `Swift.Error` model
        case failure(Swift.Error)
        
        /// Case of successful result with `BlobType` model
        case success(BlobType)
    }
    
    /// Method sends request to create user for according account.
    /// The result of request will be fetched in `completion` block as `UsersApi.GetBlobResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which blob should be fetched.
    ///   - blobId: Identifier of blob to be fetched.
    ///   - fundId: Identifier of fund for which blob should be fetched.
    ///   - tokenCode: Base asset of fund.
    ///   - fundOwner: Name of fund owner.
    ///   - type: Blob type.
    ///   - other: Extra parameters.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `UsersApi.GetBlobResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func getBlob<BlobType: Decodable>(
        _ blobType: BlobType.Type,
        accountId: String,
        blobId: String,
        fundId: String?,
        tokenCode: String?,
        fundOwner: String?,
        type: Int?,
        other: RequestParameters? = nil,
        completion: @escaping (_ result: GetBlobResult<BlobType>) -> Void
        ) -> CancellableToken {
        
        let request = self.requestBuilder.buildGetBlobRequest(
            accountId: accountId,
            blobId: blobId,
            fundId: fundId,
            tokenCode: tokenCode,
            fundOwner: fundOwner,
            type: type,
            other: other
        )
        
        return self.network.responseObject(
            ApiDataResponse<BlobType>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors))
                    
                case .success(let object):
                    completion(.success(object.data))
                }
        })
    }
}

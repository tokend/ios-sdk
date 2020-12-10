import Foundation

/// Class provides functionality that allows to fetch account data
public class AccountsApi: BaseApi {
    
    let requestBuilder: AccountsRequestBuilder
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = AccountsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in `completion` block of ` AccountsApi.requestAccount(...)`
    public enum RequestAccountResult {
        
        /// Errors that are possible to be fetched.
        public enum RequestError: Swift.Error, LocalizedError {
            case accountNotCreated
            case other(ApiErrors)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .accountNotCreated:
                    return "Account not created"
                case .other(let errors):
                    return errors.localizedDescription
                }
            }
        }
        
        /// Case of succesful response from api with `AccountResponse` model
        case success(account: AccountResponse)
        
        /// Case of failed response from api with `AccountsApi.RequestAccountResult.RequestError` model
        case failure(RequestError)
    }
    
    /// Method sends request to get account data from api.
    /// The result of request will be fetched in `completion` block as `AccountsApi.RequestAccountResult`
    /// - Parameters:
    ///   - accountId: Identifier of account to be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `AccountsApi.RequestAccountResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAccount(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestAccountResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildAccountRequest(
            accountId: accountId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.other(.failedToSignRequest)))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    AccountResponse.self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    completion: { (result) in
                        switch result {
                            
                        case .success(let object):
                            completion(.success(account: object))
                            
                        case .failure(let errors):
                            if errors.contains(status: ApiError.Status.notFound) {
                                completion(.failure(.accountNotCreated))
                            } else {
                                completion(.failure(.other(errors)))
                            }
                        }
                })
        })
        
        return cancelable
    }
    
    /// Model that will be fetched in completion block of `AccountsApi.requestSigners(...)`
    public enum RequestSignersResult {
        
        /// Case of successful response from api with `SignersResponse` model
        case success(signers: SignersResponse)
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to get signers for according account from api.
    /// The result of request will be fetched in `completion` block as `AccountsApi.RequestSignersResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which signers will be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `AccountsApi.RequestSignersResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestSigners(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestSignersResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildSignersRequest(
            accountId: accountId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    SignersResponse.self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    completion: { (result) in
                        switch result {
                            
                        case .success(let object):
                            completion(.success(signers: object))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
    
    /// Model that will be fetched in completion block of `AccountsApi.requestAuthResult(...)`
    public enum RequestAuthResult {
        
        /// Case of successful response from api with `AuthResultResponse` model
        case success(AuthResultResponse)
        
        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to get authentication result for according account from api.
    /// The result of request will be fetched in `completion` block as `AccountsApi.RequestAuthResult`
    /// - Parameters:
    ///   - accountId: Identifier of account which was used to perform authentication
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `AccountsApi.RequestAuthResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAuthResult(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestAuthResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildAuthRequestRequest(
            accountId: accountId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    AuthResultResponse.self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    completion: { (result) in
                        switch result {
                            
                        case .success(let object):
                            completion(.success(object))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
    
    /// Model that will be fetched in completion block of `AccountsApi.requestSendAuthResult(...)`
    public enum RequestSendAuthResult {
        
        /// Case of successful response from api
        case success
        
        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
    }
    /// Method sends request to post authentication result for according account.
    /// The result of request will be fetched in `completion` block as `AccountsApi.RequestSendAuthResult`
    /// - Parameters:
    ///   - accountId: Identifier of account which was used to perform authentication
    ///   - parameters: Parameters that used to define the result of authentication
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `AccountsApi.RequestSendAuthResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestSendAuthResult(
        accountId: String,
        parameters: SendAuthResultRequestParameters,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestSendAuthResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildSendAuthRequestRequest(
            accountId: accountId,
            parameters: parameters,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseJSON(
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    completion: { (result) in
                        switch result {
                            
                        case .success:
                            completion(.success)
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
}

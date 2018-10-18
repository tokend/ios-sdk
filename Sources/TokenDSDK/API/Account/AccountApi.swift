import Foundation

/// Class provides functionality that allows to fetch account data
public class AccountApi: BaseApi {
    
    let requestBuilder: AccountRequestBuilder
    
    public override init(apiStack: BaseApiStack) {
        self.requestBuilder = AccountRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in `completion` block of ` AccountApi.requestAccount(...) `
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
        
        /// Case of succesful response from api with `Account` model
        case success(account: Account)
        
        /// Case of failed response from api with `AccountApi.RequestAccountResult.RequestError` model
        case failure(RequestError)
    }
    
    /// Method sends request to get account data from api.
    /// The result of request will be fetched in `completion` block as `AccountApi.RequestAccountResult`
    /// - Parameters:
    ///   - accountId: Identifier of account to be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `AccountApi.RequestAccountResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func requestAccount(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestAccountResult) -> Void
        ) -> CancellableToken {
        
        let request = self.requestBuilder.buildAccountRequest(
            accountId: accountId,
            sendDate: sendDate
        )
        
        return self.network.responseObject(
            Account.self,
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
    }
    
    /// Model that will be fetched in completion block of `AccountApi.requestSigners(...)`
    public enum RequestSignersResult {
        
        /// Case of succesful response from api with `Signers` model
        case success(signers: Signers)
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to get signers for according account from api.
    /// The result of request will be fetched in `completion` block as `AccountApi.RequestAccountResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which signers will be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `AccountApi.RequestSignersResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func requestSigners(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestSignersResult) -> Void
        ) -> CancellableToken {
        
        let request = self.requestBuilder.buildSignersRequest(
            accountId: accountId,
            sendDate: sendDate
        )
        
        return self.network.responseObject(
            Signers.self,
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
    }
}

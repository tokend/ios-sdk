import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch account data
public class AccountsApiV3: JSONAPI.BaseApi {
    
    public let requestBuilder: AccountsRequestBuilderV3
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = AccountsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in `completion` block of ` AccountsApiV3.requestAccount(...) `
    public enum RequestAccountResult<AccountResourceType: AccountResource> {
        
        /// Errors that are possible to be fetched.
        public enum RequestError: Swift.Error, LocalizedError {
            
            /// Indicating that corresponding account doesn't exist
            case accountNotCreated
            
            /// Other errors
            case other(Error)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                    
                case .accountNotCreated:
                    return "Account doesn't exist"
                    
                case .other(let error):
                    return error.localizedDescription
                }
            }
        }
        
        /// Case of successful response with document which contains list of `ResourceType`
        case success(Document<AccountResourceType>)
        
        /// Case of failed response with `ErrorObject` model
        case failure(RequestError)
    }
    
    /// Method sends request to get account data from api.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - accountId: Identifier of account to be fetched.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestAccountResult<AccountResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAccount(
        accountId: String,
        completion: @escaping (_ result: RequestSingleResult<AccountResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildAccountRequest(
            accountId: accountId,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    AccountResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let error):
                           completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })
        
        return cancelable
    }
    
    /// Method sends request to get signers for exact account.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - accountId: Identifier of account fro which signers to be fetched.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<SignerResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestSigners(
        accountId: String,
        completion: @escaping (_ result: RequestCollectionResult<SignerResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildSignersRequest(
            accountId: accountId,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    SignerResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })
        
        return cancelable
    }
}

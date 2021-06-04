import Foundation

public extension IdentitiesApi {
    
    /// Model that will be fetched in `completion` block of `GeneralApi.requestAccountId(...)`
    @available(*, deprecated)
    enum RequestIdentitiesResult<SpecificAttributes: Decodable> {
        
        /// Case of failed response with `ApiErrors` model
        case failed(Swift.Error)
        
        /// Case of successful response with `AccountIdentityResponse` model
        case succeeded(identities: [AccountIdentityResponse<SpecificAttributes>])
    }
    /// Method sends request to get identities via login or accountId.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestIdentitiesResult`
    /// - Parameters:
    ///   - filter: Filter which will be used to fetch identities.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.RequestIdentitiesResult`
    @available(*, deprecated, message: "Use requestIdentities instead")
    func requestIdentities<SpecificAttributes: Decodable>(
        filter: RequestIdentitiesFilter,
        completion: @escaping (_ result: RequestIdentitiesResult<SpecificAttributes>) -> Void
    ) {
        
        self.requestIdentities(
            filter: filter,
            completion: { (result: Swift.Result<[AccountIdentityResponse<SpecificAttributes>], Swift.Error>) in
                
                switch result {
                
                case .success(let identities):
                    completion(.succeeded(identities: identities))
                    
                case .failure(let errors):
                    completion(.failed(errors))
                }
            }
        )
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.addIdentity(...)`
    @available(*, deprecated)
    enum AddIdentityResult<SpecificAttributes: Decodable> {
        case success(identity: AccountIdentityResponse<SpecificAttributes>)
        case failure(error: Error)
    }
    
    /// Method sends request to create new identity using phone number.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestAddIdentityResult`
    /// - Parameters:
    ///   - phoneNumber: New identity's phone number
    ///   - completion: Block that will be called when the result will be received.
    @available(*, deprecated, message: "Use addIdentity instead")
    func addIdentity<SpecificAttributes: Decodable>(
        withPhoneNumber phoneNumber: String,
        completion: @escaping ((AddIdentityResult<SpecificAttributes>) -> Void)
    ) {
        
        self.addIdentity(
            withPhoneNumber: phoneNumber,
            completion: { (result: Swift.Result<AccountIdentityResponse<SpecificAttributes>, Swift.Error>) in
                
                switch result {
                
                case .success(let identity):
                    completion(.success(identity: identity))
                    
                case .failure(let error):
                    completion(.failure(error: error))
                }
            }
        )
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.deleteIdentity(...)`
    @available(*, deprecated)
    enum DeleteIdentityResult {
        case success
        case failure(Swift.Error)
    }
    
    /// Method sends request to create new identity using phone number.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestDeleteIdentityResult`
    /// - Parameters:
    ///   - phoneNumber: Identity's accountId
    ///   - completion: Block that will be called when the result will be received.
    @discardableResult
    @available(*, deprecated, message: "Use deleteIdentity instead")
    func deleteIdentity(
        for accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (DeleteIdentityResult) -> Void
    ) -> Cancelable {
        
        return deleteIdentity(
            for: accountId,
            sendDate: sendDate,
            completion: { (result: Swift.Result<Void, Swift.Error>) in
                
                switch result {
                
                case .failure(let errors):
                    completion(.failure(errors))
                    
                case .success:
                    completion(.success)
                }
            }
        )
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.requestSetPhone(...)`
    @available(*, deprecated)
    enum SetPhoneRequestResult {
        /// Case of failed response with `ApiErrors` model
        case failed(Swift.Error)
        
        /// Case of failed tfa
        case tfaFailed
        
        /// Case of cancelled tfa
        case tfaCancelled
        
        /// Case of successful response
        case succeeded
    }
    /// Method sends request to set phone for account with given accountId.
    /// The result of request will be fetched in `completion` block as `GeneralApi.SetPhoneRequestResult`
    /// - Parameters:
    ///   - accountId: Account id of account for which it is necessary to set phone.
    ///   - phone: Model that contains phone to be set.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.SetPhoneRequestResult`
    @available(*, deprecated, message: "Use requestSetPhone instead")
    func requestSetPhone(
        accountId: String,
        phone: String,
        completion: @escaping (_ result: SetPhoneRequestResult) -> Void
        ) {
        
        self.requestSetPhone(
            accountId: accountId,
            phone: phone,
            completion: { (result: Swift.Result<Void, Swift.Error>) in
         
                switch result {
                
                case .success:
                    completion(.succeeded)
                    
                case .failure(let error):
                    
                    switch error {
                    
                    case RequestSetPhoneError.tfaCancelled:
                        completion(.tfaCancelled)
                        
                    case RequestSetPhoneError.tfaFailed:
                        completion(.tfaFailed)
                        
                    default:
                        completion(.failed(error))
                    }
                }
            }
        )
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.requestSetTelegram(...)`
    @available(*, deprecated)
    enum SetTelegramRequestResult {
        /// Case of failed response with `ApiErrors` model
        case failed(Swift.Error)
        
        /// Case of failed tfa
        case tfaFailed
        
        /// Case of cancelled tfa
        case tfaCancelled
        
        /// Case of successful response
        case succeeded
    }
    
    /// Method sends request to set telegram for account with given accountId.
    /// The result of request will be fetched in `completion` block as `GeneralApi.SetTelegramRequestResult`
    /// - Parameters:
    ///   - accountId: Account id of account for which it is necessary to set phone.
    ///   - telegram: Model that contains telegram to be set.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.SetTelegramRequestResult`
    @available(*, deprecated, message: "Use requestSetTelegram instead")
    func requestSetTelegram(
        accountId: String,
        telegram: String,
        completion: @escaping (_ result: SetTelegramRequestResult) -> Void
        ) {
        
        self.requestSetTelegram(
            accountId: accountId,
            telegram: telegram,
            completion: { (result: Swift.Result<Void, Swift.Error>) in
                
                switch result {
                
                case .success:
                    completion(.succeeded)
                    
                case .failure(let error):
                    
                    switch error {
                    
                    case RequestSetPhoneError.tfaCancelled:
                        completion(.tfaCancelled)
                        
                    case RequestSetPhoneError.tfaFailed:
                        completion(.tfaFailed)
                        
                    default:
                        completion(.failed(error))
                    }
                }
            }
        )
    }
}

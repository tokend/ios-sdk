import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch identities
public class IdentitiesApi: BaseApi {
    
    // MARK: - Internal properties
    
    internal let requestBuilder: IdentitiesRequestBuilder
    
    // MARK: -
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = IdentitiesRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
}

// MARK: - Public methods

public extension IdentitiesApi {
    
    /// Model that is used to define filter whick will be used to fetch identities
    enum RequestIdentitiesFilter {
        
        /// Filter is used when it is needed to fetch identities by accountId
        case accountId(_ accountId: String)

        /// Filter is used when it is needed to fetch identities by login
        @available(*, deprecated, renamed: "login")
        case email(_ email: String)
        case login(_ login: String)
        
        /// Filter is used when it is needed to fetch identities by phone number
        case phone(_ phone: String)
        
        /// Filter is used when it is needed to fetch identities by telegram username
        case telegram(_ telegram: String)
        
        /// Filter is used when it is needed to fetch identities by a specific parameter
        case custom(_ key: String, _ value: String)
    }
    /// Method sends request to get identities via login or accountId.
    /// The result of request will be fetched in `completion` block as `Swift.Result<[IdentityResponse<SpecificAttributes>], Swift.Error>`
    /// - Parameters:
    ///   - filter: Filter which will be used to fetch identities.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Swift.Result<[IdentityResponse<SpecificAttributes>], Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func requestIdentities<SpecificAttributes: Decodable>(
        filter: RequestIdentitiesFilter,
        completion: @escaping (Swift.Result<[IdentityResponse<SpecificAttributes>], Swift.Error>) -> Void
    ) -> Cancelable {
        
        let request = self.requestBuilder.buildGetIdentitiesRequest(filter: filter)
        
        return self.network.responseObject(
            ApiDataResponse<[IdentityResponse<SpecificAttributes>]>.self,
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
    
    /// Method sends request to create new identity using phone number.
    /// The result of request will be fetched in `completion` block as `Swift.Result<IdentityResponse<SpecificAttributes>, Swift.Error>`
    /// - Parameters:
    ///   - phoneNumber: New identity's phone number
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Swift.Result<IdentityResponse<SpecificAttributes>, Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func addIdentity<SpecificAttributes: Decodable>(
        withPhoneNumber phoneNumber: String,
        completion: @escaping (Swift.Result<IdentityResponse<SpecificAttributes>, Swift.Error>) -> Void
    ) -> Cancelable {
        
        let encodedRequest: [String: Any]
        do {
            let body: AddIdentityRequestBody = .init(phoneNumber: phoneNumber)
            encodedRequest = try body.documentDictionary()
        } catch {
            completion(.failure(error))
            return network.getEmptyCancelable()
        }
        
        let request = self.requestBuilder
            .buildAddIdentityRequest(
                bodyParameters: encodedRequest
            )
        
        return self.network.responseObject(
            ApiDataResponse<IdentityResponse<SpecificAttributes>>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                
                switch result {
                
                case .success(object: let object):
                    completion(.success(object.data))
                case .failure(errors: let errors):
                    completion(.failure(errors))
                }
            })
    }
    
    /// Method sends request to create new identity using phone number.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestDeleteIdentityResult`
    /// - Parameters:
    ///   - phoneNumber: Identity's accountId
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Swift.Result<Void, Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func deleteIdentity(
        for accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (Swift.Result<Void, Swift.Error>) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildDeleteIdentityRequest(
            accountId: accountId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseDataEmpty(
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    bodyData: nil,
                    completion: { result in
                        switch result {
                        
                        case .success:
                            completion(.success(()))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
    
    enum RequestSetPhoneError: Swift.Error, LocalizedError {
        
        case tfaFailed
        case tfaCancelled

        // MARK: - Swift.Error

        public var errorDescription: String? {
            switch self {

            case .tfaFailed:
                return "TFA failed"
                
            case .tfaCancelled:
                return "TFA cancelled"
            }
        }
    }
    /// Method sends request to set phone for account with given accountId.
    /// The result of request will be fetched in `completion` block as `GeneralApi.SetPhoneRequestResult`
    /// - Parameters:
    ///   - accountId: Account id of account for which it is necessary to set phone.
    ///   - phone: Model that contains phone to be set.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Swift.Result<Void, Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func requestSetPhone(
        accountId: String,
        phone: String,
        completion: @escaping (Swift.Result<Void, Swift.Error>) -> Void
        ) -> Cancelable {
        
        let encodedRequest: [String: Any]
        do {
            let body: SetPhoneRequestBody = .init(phone: phone)
            encodedRequest = try body.documentDictionary()
        } catch {
            completion(.failure(error))
            return network.getEmptyCancelable()
        }
        
        let request = self.requestBuilder.buildSetPhoneIdentityRequest(
            accountId: accountId,
            bodyParameters: encodedRequest
        )
        
        return self.network.responseJSON(
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    errors.checkTFARequired(
                        handler: self.tfaHandler,
                        initiateTFA: true,
                        onCompletion: { result in
                            switch result {
                                
                            case .failure:
                                completion(.failure(RequestSetPhoneError.tfaFailed))
                                
                            case .success:
                                self.requestSetPhone(
                                    accountId: accountId,
                                    phone: phone,
                                    completion: completion
                                )
                                
                            case .canceled:
                                completion(.failure(RequestSetPhoneError.tfaCancelled))
                            }
                    },
                        onNoTFA: {
                            completion(.failure(errors))
                    })
                    
                case .success:
                    completion(.success(()))
                }
        })
    }
    
    enum RequestSetTelegramError: Swift.Error, LocalizedError {
        
        case tfaFailed
        case tfaCancelled

        // MARK: - Swift.Error

        public var errorDescription: String? {
            switch self {

            case .tfaFailed:
                return "TFA failed"
                
            case .tfaCancelled:
                return "TFA cancelled"
            }
        }
    }
    /// Method sends request to set telegram for account with given accountId.
    /// The result of request will be fetched in `completion` block as `GeneralApi.SetTelegramRequestResult`
    /// - Parameters:
    ///   - accountId: Account id of account for which it is necessary to set phone.
    ///   - telegram: Model that contains telegram to be set.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Swift.Result<Void, Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func requestSetTelegram(
        accountId: String,
        telegram: String,
        completion: @escaping (Swift.Result<Void, Swift.Error>) -> Void
        ) -> Cancelable {
        
        let encodedRequest: [String: Any]
        do {
            let body: SetTelegramRequestBody = .init(username: telegram)
            encodedRequest = try body.documentDictionary()
        } catch {
            completion(.failure(error))
            return network.getEmptyCancelable()
        }
        
        let request = self.requestBuilder.buildSetTelegramIdentityRequest(
            accountId: accountId,
            bodyParameters: encodedRequest
        )
        
        return self.network.responseJSON(
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    errors.checkTFARequired(
                        handler: self.tfaHandler,
                        initiateTFA: true,
                        onCompletion: { result in
                            switch result {
                                
                            case .failure:
                                completion(.failure(RequestSetTelegramError.tfaFailed))
                                
                            case .success:
                                self.requestSetTelegram(
                                    accountId: accountId,
                                    telegram: telegram,
                                    completion: completion
                                )
                                
                            case .canceled:
                                completion(.failure(RequestSetTelegramError.tfaCancelled))
                            }
                    },
                        onNoTFA: {
                            completion(.failure(errors))
                    })
                    
                case .success:
                    completion(.success(()))
                }
        })
    }
}

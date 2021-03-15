import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch data which is necessary
/// for other requests building
public class GeneralApi: BaseApi {
    
    // MARK: - Private properties
    
    private let transportSecurityErrorStatus: String = "-1022"
    
    // MARK: - Public properties
    
    let requestBuilder: GeneralRequestBuilder
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = GeneralRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in completion block of `GeneralApi.requestNetworkInfo(...)`
    public enum RequestNetworkInfoResult {
        
        /// Errors that are able to be fetched while trying to get network info
        public enum RequestError: Swift.Error, LocalizedError {
            case failedToDecode(NetworkInfoResponse)
            case requestError(ApiErrors)
            case transportSecurity
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .failedToDecode:
                    return "Failed to decode network info"
                case .requestError(let errors):
                    return errors.localizedDescription
                case .transportSecurity:
                    return "HTTP connections are restricted because of iOS security policy"
                }
            }
        }
        
        /// Case of failed response with `RequestError` model
        case failed(RequestError)
        
        /// Case of successful response with `NetworkInfoModel` model
        case succeeded(NetworkInfoModel)
    }
    
    /// Method sends request to get network info.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestNetworkInfoResult`
    public func requestNetworkInfo(
        completion: @escaping (RequestNetworkInfoResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildGetNetworkInfoRequest()
        
        let requestTime = Date()
        self.network.responseObject(
            NetworkInfoResponse.self,
            url: request.url,
            method: request.method) { (result) in
                let responseTime = Date()
                switch result {
                    
                case .success(let object):
                    if let networkInfo = NetworkInfoModel(
                        networkInfoResponse: object,
                        requestTime: requestTime,
                        responseTime: responseTime
                        ) {
                        
                        completion(.succeeded(networkInfo))
                    } else {
                        completion(.failed(.failedToDecode(object)))
                    }
                    
                case .failure(let errors):
                    if errors.contains(status: self.transportSecurityErrorStatus) {
                        completion(.failed(.transportSecurity))
                    } else {
                        completion(.failed(.requestError(errors)))
                    }
                }
        }
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.requestAccountId(...)`
    public enum RequestIdentitiesResult<SpecificAttributes: Decodable> {
        
        /// Case of failed response with `ApiErrors` model
        case failed(ApiErrors)
        
        /// Case of successful response with `AccountIdentityResponse` model
        case succeeded(identities: [AccountIdentityResponse<SpecificAttributes>])
    }
    
    /// Model that is used to define filter whick will be used to fetch identities
    public enum RequestIdentitiesFilter {
        
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
    }
    
    /// Method sends request to get identities via login or accountId.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestIdentitiesResult`
    /// - Parameters:
    ///   - filter: Filter which will be used to fetch identities.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.RequestIdentitiesResult`
    public func requestIdentities<SpecificAttributes: Decodable>(
        filter: RequestIdentitiesFilter,
        completion: @escaping (_ result: RequestIdentitiesResult<SpecificAttributes>) -> Void
    ) {
        
        let request = self.requestBuilder.buildGetIdentitiesRequest(filter: filter)
        
        self.network.responseObject(
            ApiDataResponse<[AccountIdentityResponse<SpecificAttributes>]>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    completion(.failed(errors))
                    
                case .success(let object):
                    completion(.succeeded(identities: object.data))
                }
        })
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.addIdentity(...)`
    public enum RequestAddIdentityResult<SpecificAttributes: Decodable> {
        case success(identity: AccountIdentityResponse<SpecificAttributes>)
        case failure(error: Error)
    }
    
    /// Method sends request to create new identity using phone number.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestAddIdentityResult`
    /// - Parameters:
    ///   - phoneNumber: New identity's phone number
    ///   - completion: Block that will be called when the result will be received.
    public func addIdentity<SpecificAttributes: Decodable>(
        withPhoneNumber phoneNumber: String,
        completion: @escaping ((RequestAddIdentityResult<SpecificAttributes>) -> Void)
    ) {
        
        let body: AddIdentityRequestBody = .init(phoneNumber: phoneNumber)
        
        guard let encodedRequest = try? body.documentDictionary() else {
            completion(.failure(error: JSONAPIError.failedToBuildRequest))
            return
        }
        
        let request = self.requestBuilder
            .buildAddIdentityRequest(
                bodyParameters: encodedRequest
            )
        
        self.network.responseObject(
            ApiDataResponse<AccountIdentityResponse<SpecificAttributes>>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                
                switch result {
                
                case .success(object: let object):
                    completion(.success(identity: object.data))
                case .failure(errors: let errors):
                    completion(.failure(error: errors))
                }
            })
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.deleteIdentity(...)`
    public enum RequestDeleteIdentityResult {
        case success
        case failure(ApiErrors)
    }
    
    /// Method sends request to create new identity using phone number.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestDeleteIdentityResult`
    /// - Parameters:
    ///   - phoneNumber: Identity's accountId
    ///   - completion: Block that will be called when the result will be received.
    @discardableResult
    public func deleteIdentity(
        for accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (RequestDeleteIdentityResult) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildDeleteIdentityRequest(
            accountId: accountId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
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
                            completion(.success)
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.requestSetPhone(...)`
    public enum SetPhoneRequestResult {
        /// Case of failed response with `ApiErrors` model
        case failed(Swift.Error)
        
        /// Case of failed tfa
        case tfaFailed
        
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
    public func requestSetPhone(
        accountId: String,
        phone: SetPhoneRequestBody,
        completion: @escaping (_ result: SetPhoneRequestResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildSetPhoneIdentityRequest(
            accountId: accountId,
            body: phone
        )
        
        self.network.responseJSON(
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
                                completion(.tfaFailed)
                                
                            case .success:
                                self.requestSetPhone(
                                    accountId: accountId,
                                    phone: phone,
                                    completion: completion
                                )
                                
                            case .canceled:
                                completion(.tfaFailed)
                            }
                    },
                        onNoTFA: {
                            completion(.failed(errors))
                    })
                    
                case .success:
                    completion(.succeeded)
                }
        })
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.requestSetTelegram(...)`
    public enum SetTelegramRequestResult {
        /// Case of failed response with `ApiErrors` model
        case failed(Swift.Error)
        
        /// Case of failed tfa
        case tfaFailed
        
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
    public func requestSetTelegram(
        accountId: String,
        telegram: SetTelegramRequestBody,
        completion: @escaping (_ result: SetTelegramRequestResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildSetTelegramIdentityRequest(
            accountId: accountId,
            body: telegram
        )
        
        self.network.responseJSON(
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
                                completion(.tfaFailed)
                                
                            case .success:
                                self.requestSetTelegram(
                                    accountId: accountId,
                                    telegram: telegram,
                                    completion: completion
                                )
                                
                            case .canceled:
                                completion(.tfaFailed)
                            }
                    },
                        onNoTFA: {
                            completion(.failed(errors))
                    })
                    
                case .success:
                    completion(.succeeded)
                }
        })
    }
    
    /// Model that will be fetched in completion block of `GeneralApi.requestFee(...)`
    public enum RequestFeeResult {
        
        /// Case of failed response with `ApiErrors` model
        case failed(ApiErrors)
        
        /// Case of successful response with `FeeResponse` model
        case succeeded(FeeResponse)
    }
    
    /// Method sends request to get fee.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestFeeResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which fee should be fetched.
    ///   - asset: Asset of amount for which fee should be fetched.
    ///   - feeType: Type of fee to be fetched.
    ///   - amount: Amount for which fee should be fetched.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.RequestFeeResult`
    public func requestFee(
        accountId: String,
        asset: String,
        feeType: FeeResponse.FeeType,
        amount: Decimal?,
        subtype: Int32 = 0,
        completion: @escaping (_ result: RequestFeeResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildGetFeeRequest(
            accountId: accountId,
            asset: asset,
            feeType: feeType,
            amount: amount,
            subtype: subtype
        )
        
        self.network.responseObject(
            FeeResponse.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    completion(.failed(errors))
                    
                case .success(let object):
                    completion(.succeeded(object))
                }
        })
    }
    
    /// Model that will be fetched in completion block of `GeneralApi.requestFeesOverview(...)`
    public enum FeesOverviewResult {
        
        /// Case of failed response with `ApiErrors` model
        case failed(ApiErrors)
        
        /// Case of successful response with `FeesOverviewResponse` model
        case succeeded(FeesOverviewResponse)
    }
    
    /// Method sends request to get fees overview.
    /// The result of request will be fetched in `completion` block as `GeneralApi.FeesOverviewResult`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.FeesOverviewResult`
    public func requestFeesOverview(completion: @escaping (_ result: FeesOverviewResult) -> Void) {
        let request = self.requestBuilder.buildGetFeesOverviewRequest()
        self.network.responseObject(
            FeesOverviewResponse.self,
            url: request.url,
            method: request.method,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    completion(.failed(error))
                    
                case .success(let object):
                    completion(.succeeded(object))
                }
            })
    }
}

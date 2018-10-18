import Foundation

/// Class provides functionality that allows to fetch data which is necessary
/// for other requests building
public class GeneralApi: BaseApi {
    let requestBuilder: GeneralRequestBuilder
    
    public override init(apiStack: BaseApiStack) {
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
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .failedToDecode:
                    return "Failed to decode network info"
                case .requestError(let errors):
                    return errors.localizedDescription
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
                    completion(.failed(.requestError(errors)))
                }
        }
    }
    
    /// Model that will be fetched in `completion` block of `GeneralApi.requestAccountId(...)`
    public enum RequestAccountIdResult {
        
        /// Errors that are able to be fetched while trying to get account id
        public enum RequestAccountIdError: Swift.Error, LocalizedError {
            case wrongEmail
            case other(ApiErrors)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .wrongEmail:
                    return "Wrong Email"
                case .other(let errors):
                    return errors.localizedDescription
                }
            }
        }
        
        /// Case of failed response with `RequestAccountIdError` model
        case failed(RequestAccountIdError)
        
        /// Case of successful response with `UserAccountIdResponse` model
        case succeeded(UserAccountIdResponse)
    }
    
    /// Method sends request to get account id for according email.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestAccountIdResult`
    /// - Parameters:
    ///   - email: Email which will be used to fetch account id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.RequestAccountIdResult`
    public func requestAccountId(
        email: String,
        completion: @escaping (_ result: RequestAccountIdResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildGetAccountIdRequest(email: email)
        
        self.network.responseObject(
            UserAccountIdResponse.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEcoding,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    if errors.contains(status: ApiError.Status.notFound) {
                        completion(.failed(.wrongEmail))
                    } else {
                        completion(.failed(.other(errors)))
                    }
                    
                case .success(let object):
                    completion(.succeeded(object))
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
        completion: @escaping (_ result: RequestFeeResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildGetFeeRequest(
            accountId: accountId,
            asset: asset,
            feeType: feeType,
            amount: amount
        )
        
        self.network.responseObject(
            FeeResponse.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEcoding,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    completion(.failed(errors))
                    
                case .success(let object):
                    completion(.succeeded(object))
                }
        })
    }
}

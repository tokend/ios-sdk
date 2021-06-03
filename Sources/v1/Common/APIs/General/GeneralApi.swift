import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch data which is necessary
/// for other requests building
public class GeneralApi: BaseApi {
    
    // MARK: - Private properties
    
    private let transportSecurityErrorStatus: String = "-1022"
    
    // MARK: - Public properties
    
    internal let requestBuilder: GeneralRequestBuilder
    internal let identitiesApi: IdentitiesApi
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = GeneralRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        self.identitiesApi = .init(apiStack: apiStack)
        
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

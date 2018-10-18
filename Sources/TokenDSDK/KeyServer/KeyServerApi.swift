import Foundation
import DLCryptoKit
import TokenDWallet

/// Allows to send Key Server related requests.
public class KeyServerApi {
    
    // MARK: - Public properties
    
    public let apiConfiguration: ApiConfiguration
    public let requestBuilder: KeyServerApiRequestBuilder
    public let network: Network
    
    let tfaHandler: TFAHandler
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        callbacks: ApiCallbacks,
        verifyApi: TFAVerifyApi,
        requestSigner: RequestSignerProtocol
        ) {
        self.apiConfiguration = apiConfiguration
        self.requestBuilder = KeyServerApiRequestBuilder(apiConfiguration: apiConfiguration)
        self.tfaHandler = TFAHandler(
            callbacks: callbacks,
            verifyApi: verifyApi
        )
        self.network = Network(userAgent: apiConfiguration.userAgent)
    }
    
    // MARK: - Public -
    
    // MARK: KDF
    
    /// Result model for `completion` block of `KeyServerApi.requestDefaultKDF(...)`
    public enum RequestDefaultKDFResult {
        
        /// Errors that may occur for `KeyServerApi.requestDefaultKDF(...)`
        public enum RequestError: Swift.Error, LocalizedError {
            
            /// Unrecognized error. Contains `ApiErrors`
            case unknown(ApiErrors)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .unknown(let errors):
                    return errors.localizedDescription
                }
            }
        }
        
        /// Case of successful response from api with `KDFParams` model
        case success(kdfParams: KDFParams)
        
        /// Case of failed response from api with `KeyServerApi.RequestDefaultKDFResult.RequestError` model
        case failure(RequestError)
    }
    
    /// Method sends request to get default KDF params from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestDefaultKDFResult`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestDefaultKDFResult`
    public func requestDefaultKDF(
        completion: @escaping (_ result: RequestDefaultKDFResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildGetKDFParamsRequest()
        
        self.network.responseObject(
            ApiDataResponse<GetKDFParamsResponse>.self,
            url: request.url,
            method: request.method,
            encoding: request.parametersEncoding,
            completion: { result in
                switch result {
                    
                case .success(let kdfResponse):
                    let kdfParams = KDFParams.fromResponse(kdfResponse.data)
                    completion(.success(kdfParams: kdfParams))
                    
                case .failure(let errors):
                    let requestError: RequestDefaultKDFResult.RequestError = .unknown(errors)
                    completion(.failure(requestError))
                }
        })
    }
    
    /// Result model for `completion` block of `KeyServerApi.requestWalletKDF(...)`
    public enum RequestWalletKDFResult {
        
        /// Errors that may occur for `KeyServerApi.requestWalletKDF(...)`
        public enum RequestError: Swift.Error, LocalizedError {
            
            /// KDF params not found for given email.
            case emailNotFound
            
            /// Unrecognized error. Contains `ApiErrors`
            case unknown(ApiErrors)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .emailNotFound:
                    return "KDF for email not found"
                case .unknown(let errors):
                    return errors.localizedDescription
                }
            }
        }
        
        /// Case of successful response from api with `WalletKDFParams` model
        case success(walletKDF: WalletKDFParams)
        
        /// Case of failed response from api with `KeyServerApi.RequestWalletKDFResult.RequestError` model
        case failure(RequestError)
    }
    
    /// Method sends request to get wallet KDF params from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestWalletKDFResult`
    /// - Parameters:
    ///   - email: Email of associated wallet.
    ///   - isRecovery: Indicates whether is recovery wallet data should be fetched. Default is **false**.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletKDFResult`
    /// - Returns: Cancellable token.
    @discardableResult
    public func requestWalletKDF(
        email: String,
        isRecovery: Bool = false,
        completion: @escaping (_ result: RequestWalletKDFResult) -> Void
        ) -> CancellableToken {
        
        let request = self.requestBuilder.buildGetWalletKDFRequest(email: email, isRecovery: isRecovery)
        
        return self.network.responseObject(
            ApiDataResponse<GetWalletKDFResponse>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { result in
                switch result {
                    
                case .success(let walletKDFResponse):
                    guard let walletKDF = WalletKDFParams.fromResponse(walletKDFResponse.data) else {
                        completion(.failure(.emailNotFound))
                        return
                    }
                    completion(.success(walletKDF: walletKDF))
                    
                case .failure(let errors):
                    let requestError: RequestWalletKDFResult.RequestError
                    if errors.contains(status: ApiError.Status.notFound) {
                        requestError = .emailNotFound
                    } else {
                        requestError = .unknown(errors)
                    }
                    completion(.failure(requestError))
                }
        })
    }
    
    // MARK: Login
    
    /// Result model for `completion` block of `KeyServerApi.loginWith(...)`
    public enum LoginRequestResult {
        
        /// Errors that may occur for `KeyServerApi.loginWith(...)`
        public enum LoginError: Swift.Error, LocalizedError {
            
            /// Failed to decode keychain data from wallet data.
            case cannotDecodeKeychainData
            
            /// Failed to derive key pair from wallet data.
            case cannotDeriveKeyPair
            
            /// Failed to derive wallet id from wallet KDF params.
            case cannotDeriveWalletId
            
            /// Failed to fetch wallet data from api.
            case requestWalletError(RequestWalletResult.RequestWalletError)
            
            /// Failed to fetch wallet KDF params from api.
            case walletKDFError(RequestWalletKDFResult.RequestError)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .cannotDecodeKeychainData:
                    return "Cannot decode keychain data"
                case .cannotDeriveKeyPair:
                    return "Cannot derive key pair"
                case .cannotDeriveWalletId:
                    return "Cannot derive wallet id"
                case .requestWalletError(let error):
                    return error.localizedDescription
                case .walletKDFError(let error):
                    return error.localizedDescription
                }
            }
        }
        
        /// Case of successful response from api with `WalletDataModel` and `ECDSA.KeyData` models
        case success(walletData: WalletDataModel, keyPair: ECDSA.KeyData)
        
        /// Case of failed response from api with `KeyServerApi.LoginRequestResult.LoginError` model
        case failure(LoginError)
    }
    
    /// Method sends request to get wallet data from api and decypher private key.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.LoginRequestResult`
    /// - Parameters:
    ///   - email: Email of associated wallet.
    ///   - password: Password to decypher private key.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.LoginRequestResult`
    /// - Returns: Cancellable token.
    @discardableResult
    public func loginWith(
        email: String,
        password: String,
        completion: @escaping (_ result: LoginRequestResult) -> Void
        ) -> CancellableToken {
        
        var cancellable = CancellableToken(request: nil)
        cancellable = self.requestWalletKDF(email: email, completion: { [weak self] result in
            switch result {
                
            case .success(let walletKDF):
                cancellable.request = self?.continueLoginForKDF(
                    email: email,
                    password: password,
                    walletKDF: walletKDF,
                    completion: completion
                    ).request
                
            case .failure(let error):
                completion(.failure(.walletKDFError(error)))
            }
        })
        return cancellable
    }
    
    // MARK: System Info
    
    /// Result model for `completion` block of `KeyServerApi.requestSystemInfo(...)`
    public enum RequestSystemInfoResult {
        
        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
        
        /// Case of successful response from api with `SystemInfo` model
        case success(SystemInfo)
    }
    
    /// Method sends request to get system info.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestSystemInfoResult`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestSystemInfoResult`
    public func requestSystemInfo(
        completion: @escaping (_ result: RequestSystemInfoResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildRequestSystemInfoRequest()
        
        self.network.responseObject(
            SystemInfo.self,
            url: request.url,
            method: request.method,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors))
                    
                case .success(let object):
                    completion(.success(object))
                }
        })
    }
    
    // MARK: - Private
    
    @discardableResult
    private func continueLoginForKDF(
        email: String,
        password: String,
        walletKDF: WalletKDFParams,
        completion: @escaping (_ result: LoginRequestResult) -> Void
        ) -> CancellableToken {
        
        let email = walletKDF.kdfParams.checkedEmail(email)
        
        guard
            let walletId = try? KeyPairBuilder.deriveWalletId(
                forEmail: email,
                password: password,
                walletKDF: walletKDF
            ) else {
                completion(.failure(.cannotDeriveWalletId))
                return CancellableToken(request: nil)
        }
        
        let base16WalletId = walletId.hexadecimal()
        
        return self.requestWallet(
            walletId: base16WalletId,
            walletKDF: walletKDF,
            completion: { [weak self] result in
                switch result {
                    
                case .success(let walletData):
                    self?.continueLoginForWalletData(
                        email: email,
                        password: password,
                        walletKDF: walletKDF,
                        walletData: walletData,
                        completion: completion
                    )
                    
                case .failure(let error):
                    completion(.failure(.requestWalletError(error)))
                }
        })
    }
    
    private func continueLoginForWalletData(
        email: String,
        password: String,
        walletKDF: WalletKDFParams,
        walletData: WalletDataModel,
        completion: @escaping (_ result: LoginRequestResult) -> Void
        ) {
        
        guard
            let keychainData = walletData.keychainData.dataFromBase64
            else {
                completion(.failure(.cannotDecodeKeychainData))
                return
        }
        
        guard let keyPair: ECDSA.KeyData = try? KeyPairBuilder.getKeyPair(
            forEmail: email,
            password: password,
            keychainData: keychainData,
            walletKDF: walletKDF
            ) else {
                completion(.failure(.cannotDeriveKeyPair))
                return
        }
        
        completion(.success(walletData: walletData, keyPair: keyPair))
    }
}

import Foundation
import TokenDWallet
import DLCryptoKit

extension KeyServerApi {
    
    // MARK: - Public -
    
    // MARK: Update Password
    
    /// Result model for `completion` block of `KeyServerApi.updatePasswordFor(...)`
    public enum UpdatePasswordResult {
        
        /// Errors that may occur for `KeyServerApi.updatePasswordFor(...)`.
        public enum UpdateError: Swift.Error, LocalizedError {
            public typealias RequestError = Swift.Error & LocalizedError
            
            /// Failed to build request model.
            case failedToGenerateRequest(Swift.Error)
            
            /// Api request failed.
            case requestFailed(RequestError)
            
            /// TFA failed.
            case tfaFailed
            
            /// Wallet is not verified.
            case unverifiedWallet
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                    
                case .failedToGenerateRequest(let error):
                    return error.localizedDescription
                    
                case .requestFailed(let error):
                    return error.localizedDescription
                    
                case .tfaFailed:
                    return "TFA failed"
                    
                case .unverifiedWallet:
                    return "Unverified wallet"
                }
            }
        }
        
        /// Case of failed update password operation with `UpdatePasswordResult.UpdateError` model
        case failed(UpdateError)
        
        /// Case of successful update password operation
        /// with `WalletInfoModel`, `WalletDataModel` and new private `ECDSA.KeyData` models
        case succeeded(WalletInfoResponse)
    }
    
    public func performUpdatePasswordRequest(
        email: String,
        walletId: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        walletInfo: WalletInfoModel,
        requestSigner: JSONAPI.RequestSignerProtocol,
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildUpdateWalletRequest(
            walletId: walletId,
            walletInfo: walletInfo,
            requestSigner: requestSigner,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failed(.failedToGenerateRequest(ApiErrors.failedToSignRequest)))
                    return
                }
                
                cancelable.cancelable = self?.performUpdatePasswordRequest(
                    request,
                    email: email,
                    signingPassword: signingPassword,
                    walletKDF: walletKDF,
                    initiateTFA: true,
                    completion: completion
                )
        })
        
        return cancelable
    }
    
    // MARK: Wallet
    
    /// Result model for `completion` block of `KeyServerApi.requestWallet(...)`
    public enum RequestWalletResult {
        
        /// Errors that may occur for `KeyServerApi.requestWallet(...)`.
        public enum RequestWalletError: Swift.Error, LocalizedError {
            
            /// Wallet email is not verified.
            case emailShouldBeVerified(walletId: String)
            
            /// TFA failed.
            case tfaFailed
            
            /// Unrecognized error. Contains `ApiErrors` model.
            case unknown(ApiErrors)
            
            /// No existing wallet with given email is found.
            case wrongEmail
            
            /// Input password is wrong.
            case wrongPassword
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .emailShouldBeVerified:
                    return "Email should be verified"
                case .tfaFailed:
                    return "TFA failed"
                case .unknown(let errors):
                    return errors.localizedDescription
                case .wrongEmail:
                    return "Wrong email"
                case .wrongPassword:
                    return "Wrong password"
                }
            }
        }
        
        /// Case of failed response from api with `RequestWalletResult.RequestWalletError` model
        case failure(RequestWalletError)
        
        /// Case of successful response from api with `WalletDataModel` model
        case success(walletData: WalletDataModel)
    }
    
    /// Method sends request to get wallet data from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestWalletResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - walletKDF: Wallet KDF params.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestWallet(
        walletId: String,
        walletKDF: WalletKDFParams,
        completion: @escaping (_ result: RequestWalletResult) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildGetWalletRequest(walletId: walletId)
        
        return self.requestWallet(
            walletId: walletId,
            walletKDF: walletKDF,
            request: request,
            initiateTFA: true,
            completion: completion
        )
    }
    
    /// Method sends request to get wallet data from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestWalletResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - walletKDF: Wallet KDF params.
    ///   - request: Wallet request model.
    ///   - initiateTFA: Flag to initiate TFA in case of TFA required error.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestWallet(
        walletId: String,
        walletKDF: WalletKDFParams,
        request: GetWalletRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: RequestWalletResult) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        cancellable = self.network.responseObject(
            ApiDataResponse<WalletDataResponse>.self,
            url: request.url,
            method: request.method,
            completion: { [weak self] result in
                switch result {
                    
                case .success(let response):
                    let walletData = WalletDataModel.fromResponse(response.data, walletKDF: walletKDF)
                    completion(.success(walletData: walletData))
                    
                case .failure(let errors):
                    cancellable.cancelable = self?.onRequestWalletFailed(
                        walletId: walletId,
                        walletKDF: walletKDF,
                        errors: errors,
                        request: request,
                        initiateTFA: initiateTFA,
                        completion: completion
                        )
                }
        })
        return cancellable
    }
    
    /// Result model for `completion` block of `KeyServerApi.requestWalletVerificationState(...)`
    public enum RequestWalletVerificationStateResult {
        
        /// Case of unverified wallet status
        case unverified
        
        /// Case of verified wallet status
        case verified
        
        // Case of requets failure
        case failure(ApiErrors)
    }
    
    /// Method sends request to check wallet's verification status.
    /// The result of request will be fetched in `completion` block as
    /// `KeyServerApi.RequestWalletVerificationStateResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletVerificationStateResult`
    public func requestWalletVerificationState(
        walletId: String,
        completion: @escaping (_ result: RequestWalletVerificationStateResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildGetWalletRequest(walletId: walletId)
        self.network.responseObject(
            ApiDataResponse<WalletDataResponse>.self,
            url: request.url,
            method: request.method,
            completion: { result in
                switch result {
                    
                case .success:
                    completion(.verified)
                    
                case .failure(let errors):
                    if errors.contains(status: ApiError.Status.forbidden) {
                        completion(.unverified)
                    } else {
                        completion(.failure(errors))
                    }
                }
        })
    }
    
    // MARK: -
    
    /// Method to create `AccountsApi` instance.
    /// - Parameters:
    ///   - signingKey: Private key pair to sign api requests.
    /// - Returns: `AccountsApi` instance.
    public func createAccountsApiV3(
        requestSigner: JSONAPI.RequestSignerProtocol
        ) -> AccountsApiV3 {
        
        let callbacksV3 = JSONAPI.ApiCallbacks(
            onUnathorizedRequest: { _ in }
        )
        
        let accountsApiV3 = AccountsApiV3(
            apiStack: JSONAPI.BaseApiStack(
                apiConfiguration: self.apiConfiguration,
                callbacks: callbacksV3,
                network: self.networkV3.network,
                requestSigner: requestSigner
            )
        )
        
        return accountsApiV3
    }
    
    // MARK: - Private -
    
    @discardableResult
    private func onRequestWalletFailed(
        walletId: String,
        walletKDF: WalletKDFParams,
        errors: ApiErrors,
        request: GetWalletRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: RequestWalletResult) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        if errors.contains(status: ApiError.Status.forbidden, code: ApiError.Code.verificationRequired) {
            completion(.failure(.emailShouldBeVerified(walletId: walletId)))
        } else {
            errors.checkTFARequired(
                handler: self.tfaHandler,
                initiateTFA: initiateTFA,
                onCompletion: { [weak self] (tfaResult) in
                    switch tfaResult {
                        
                    case .success:
                        cancellable.cancelable = self?.requestWallet(
                            walletId: walletId,
                            walletKDF: walletKDF,
                            request: request,
                            initiateTFA: false,
                            completion: completion
                            )
                        
                    case .failure, .canceled:
                        completion(.failure(.tfaFailed))
                    }
                },
                onNoTFA: {
                    let requestError: RequestWalletResult.RequestWalletError
                    if errors.contains(status: ApiError.Status.notFound) {
                        requestError = .wrongPassword
                    } else {
                        requestError = .unknown(errors)
                    }
                    
                    completion(.failure(requestError))
            })
        }
        
        return cancellable
    }
    
    private func performUpdatePasswordRequest(
        _ request: UpdateWalletRequest,
        email: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        initiateTFA: Bool,
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        cancelable = self.network.responseDataObject(
            ApiDataResponse<WalletInfoResponse>.self,
            url: request.url,
            method: request.method,
            headers: request.signedHeaders,
            bodyData: request.registrationInfoData,
            completion: { [weak self] (result) in
                
                switch result {
                    
                case .failure(let errors):
                    if
                        let error = errors.firstErrorWith(
                            status: ApiError.Status.forbidden,
                            code: ApiError.Code.tfaRequired
                        ),
                        let meta = error.tfaMeta {
                        
                        if initiateTFA {
                            let onHandleTFAResult: (TFAResult) -> Void = { [weak self] tfaResult in
                                switch tfaResult {
                                    
                                case .success:
                                    cancelable.cancelable = self?.performUpdatePasswordRequest(
                                        request,
                                        email: email,
                                        signingPassword: signingPassword,
                                        walletKDF: walletKDF,
                                        initiateTFA: false,
                                        completion: completion
                                        )
                                    
                                case .failure, .canceled:
                                    completion(.failed(.tfaFailed))
                                }
                            }
                            
                            guard let strongSelf = self else {
                                completion(.failed(.tfaFailed))
                                return
                            }
                            
                            switch meta.factorTypeBase {
                                
                            case .codeBased:
                                self?.tfaHandler.initiateTFA(
                                    meta: meta,
                                    completion: { tfaResult in
                                        onHandleTFAResult(tfaResult)
                                })
                                
                            case .passwordBased(let metaModel):
                                TFAPasswordHandler(tfaHandler: strongSelf.tfaHandler).initiatePasswordTFA(
                                    email: email,
                                    password: signingPassword,
                                    meta: metaModel,
                                    kdfParams: walletKDF.kdfParams,
                                    completion: { tfaResult in
                                        onHandleTFAResult(tfaResult)
                                })
                            }
                        } else {
                            completion(.failed(.tfaFailed))
                        }
                    } else {
                        completion(.failed(.requestFailed(errors)))
                    }
                    
                case .success(let object):
                    completion(.succeeded(object.data))
                }
        })
        
        return cancelable
    }
    
    private func getUnsafeMutablePointer<T: Any>(_ object: T) -> UnsafeMutablePointer<T> {
        let result = UnsafeMutablePointer<T>.allocate(capacity: 1)
        result[0] = object
        return result
    }
}

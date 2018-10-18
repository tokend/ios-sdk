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
            
            /// Failed to decode original account id. `Base32Check.decodeCheck(...)` is used.
            case cannotDecodeOriginalAccountIdData
            
            /// Failed to derive encoded wallet id.
            case cannotDeriveEncodedWalletId
            
            /// Failed to derive old key from old password.
            case cannotDeriveOldKeyFrom(Swift.Error)
            
            /// Failed to derive recovery key from recovery seed.
            case cannotDeriveRecoveryKeyFromSeed(Swift.Error)
            
            /// Keychain data is corrupted.
            case corruptedKeychainData
            
            /// Failed to build request model.
            case failedToGenerateRequest(Swift.Error)
            
            /// Failed to fetch account signers.
            case failedToRetriveSigners(ApiErrors)
            
            /// Failed to generate new private key.
            case newKeyGenerationFailed(Swift.Error)
            
            /// Unrecognized error.
            case other(Swift.Error)
            
            /// Api request failed.
            case requestFailed(RequestError)
            
            /// TFA failed.
            case tfaFailed
            
            /// Wallet is not verified.
            case unverifiedWallet
            
            /// Failed to fetch wallet data.
            case walletDataError(RequestWalletResult.RequestWalletError)
            
            /// Failed to build wallet info for update password.
            /// Contains `WalletInfoBuilder.CreateUpdatePasswordResult.CreateError`.
            case walletInfoBuilderUpdatePasswordError(WalletInfoBuilder.CreateUpdatePasswordResult.CreateError)
            
            /// Failed to fetch wallet KDF params.
            case walletKDFError(RequestWalletKDFResult.RequestError)
            
            /// Input old password is wrong.
            case wrongOldPassword
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .cannotDecodeOriginalAccountIdData:
                    return "Cannot decode original account id data"
                case .cannotDeriveEncodedWalletId:
                    return "Cannot derive encoded wallet id"
                case .cannotDeriveOldKeyFrom(let error):
                    return error.localizedDescription
                case .cannotDeriveRecoveryKeyFromSeed(let error):
                    return error.localizedDescription
                case .corruptedKeychainData:
                    return "Corrupted keychain data"
                case .failedToGenerateRequest(let error):
                    return error.localizedDescription
                case .failedToRetriveSigners(let errors):
                    return errors.localizedDescription
                case .newKeyGenerationFailed(let error):
                    return error.localizedDescription
                case .other(let error):
                    return error.localizedDescription
                case .requestFailed(let error):
                    return error.localizedDescription
                case .tfaFailed:
                    return "TFA failed"
                case .unverifiedWallet:
                    return "Unverified wallet"
                case .walletDataError(let error):
                    return error.localizedDescription
                case .walletInfoBuilderUpdatePasswordError(let error):
                    return error.localizedDescription
                case .walletKDFError(let error):
                    return error.localizedDescription
                case .wrongOldPassword:
                    return "Wrong old password"
                }
            }
        }
        
        /// Case of failed update password operation with `UpdatePasswordResult.UpdateError` model
        case failed(UpdateError)
        
        /// Case of successful update password operation
        /// with `WalletInfoModel`, `WalletDataModel` and new private `ECDSA.KeyData` models
        case succeeded(
            updateInfo: WalletInfoModel,
            walletData: WalletDataModel,
            newKeyPair: ECDSA.KeyData
        )
    }
    
    /// Method to update wallet password.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.UpdatePasswordResult`
    /// - Parameters:
    ///   - email: Email of associated wallet.
    ///   - signingPassword: Password to sign update password operation.
    ///   - walletId: Wallet id.
    ///   - originalAccountId: Original account id.
    ///   - networkInfo: `NetworkInfoModel` model.
    ///   - kdf: KDF params.
    ///   - signingKeyPair: Private key pair to sign update password operation.
    ///   - accountSigners: New account signers.
    ///   - newPassword: New password.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.UpdatePasswordResult`
    /// - Returns: Cancellable token.
    /// - Note: Update Password is used by Change Password and Recover Password.
    public func updatePasswordFor(
        email: String,
        signingPassword: String,
        walletId: String,
        originalAccountId: String,
        networkInfo: NetworkInfoModel,
        kdf: KDFParams,
        signingKeyPair: ECDSA.KeyData,
        accountSigners: [Account.Signer],
        newPassword: String,
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
        ) -> CancellableToken {
        
        let cancellableToken = CancellableToken(request: nil)
        
        let newKeyPair: ECDSA.KeyData
        do {
            newKeyPair = try ECDSA.KeyData()
        } catch let error {
            completion(.failed(.newKeyGenerationFailed(error)))
            return cancellableToken
        }
        
        let passwordFactorKey: ECDSA.KeyData
        do {
            passwordFactorKey = try ECDSA.KeyData()
        } catch let error {
            completion(.failed(.newKeyGenerationFailed(error)))
            return cancellableToken
        }
        
        let sourceAccountIdData: Data
        do {
            sourceAccountIdData = try Base32Check.decodeCheck(
                expectedVersion: .accountIdEd25519,
                encoded: originalAccountId
            )
        } catch {
            completion(.failed(.cannotDecodeOriginalAccountIdData))
            return cancellableToken
        }
        
        let keychainParams = WalletInfoBuilder.KeychainParams(
            newKeyPair: newKeyPair,
            recoveryKeyPair: signingKeyPair,
            passwordFactorKey: passwordFactorKey
        )
        
        let sendDate = Date()
        let result = WalletInfoBuilder.createUpdatePasswordWalletInfo(
            email: email,
            kdf: kdf,
            signingKeyPair: signingKeyPair,
            sourceAccountIdData: sourceAccountIdData,
            accountSigners: accountSigners,
            originalAccountId: originalAccountId,
            networkInfo: networkInfo,
            newPassword: newPassword,
            keychainParams: keychainParams,
            sendDate: sendDate
        )
        
        switch result {
            
        case .failed(let createError):
            completion(.failed(.walletInfoBuilderUpdatePasswordError(createError)))
            
        case .succeeded(let walletInfo):
            let walletKDF = WalletKDFParams(
                kdfParams: kdf,
                salt: keychainParams.newKeyPairKeychainSalt
            )
            
            cancellableToken.request = self.continueUpdatePassword(
                email: email,
                walletId: walletId,
                signingPassword: signingPassword,
                walletInfo: walletInfo,
                signingKeyPair: signingKeyPair,
                newKeyPair: newKeyPair,
                walletKDF: walletKDF,
                sendDate: sendDate,
                completion: completion
                ).request
        }
        
        return cancellableToken
    }
    
    // MARK: Change wallet password
    
    /// Method to change wallet password from old to new.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.UpdatePasswordResult`
    /// - Parameters:
    ///   - email: Email of associated wallet.
    ///   - oldPassword: Old password.
    ///   - newPassword: New password.
    ///   - networkInfo: `NetworkInfoModel` model.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.UpdatePasswordResult`
    /// - Returns: Cancellable token.
    /// - Note: This method uses KeyServerApi.updatePasswordFor(...)
    public func changeWalletPassword(
        email: String,
        oldPassword: String,
        newPassword: String,
        networkInfo: NetworkInfoModel,
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
        ) -> CancellableToken {
        
        let cancellableToken = CancellableToken(request: nil)
        
        cancellableToken.request = self.requestWalletKDF(
            email: email,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    completion(.failed(.walletKDFError(error)))
                    
                case .success(let walletKDF):
                    cancellableToken.request = self?.continueChangePassword(
                        email: email,
                        oldPassword: oldPassword,
                        newPassword: newPassword,
                        networkInfo: networkInfo,
                        walletKDF: walletKDF,
                        completion: completion
                        ).request
                }
        }).request
        
        return cancellableToken
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
    /// - Returns: Cancellable token.
    @discardableResult
    public func requestWallet(
        walletId: String,
        walletKDF: WalletKDFParams,
        completion: @escaping (_ result: RequestWalletResult) -> Void
        ) -> CancellableToken {
        
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
    /// - Returns: Cancellable token.
    @discardableResult
    public func requestWallet(
        walletId: String,
        walletKDF: WalletKDFParams,
        request: GetWalletRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: RequestWalletResult) -> Void
        ) -> CancellableToken {
        
        var cancellable = CancellableToken(request: nil)
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
                    cancellable.request = self?.onRequestWalletFailed(
                        walletId: walletId,
                        walletKDF: walletKDF,
                        errors: errors,
                        request: request,
                        initiateTFA: initiateTFA,
                        completion: completion
                        ).request
                }
        })
        return cancellable
    }
    
    // MARK: -
    
    /// Method to create `AccountApi` instance.
    /// - Parameters:
    ///   - signingKey: Private key pair to sign api requests.
    /// - Returns: `AccountApi` instance.
    public func createAccountApi(signingKey: ECDSA.KeyData) -> AccountApi {
        let keyDataProvider = UnsafeRequestSignKeyDataProvider(keyPair: signingKey)
        let requestSigner = RequestSigner(keyDataProvider: keyDataProvider)
        let accountApi = AccountApi(
            apiStack: BaseApiStack(
                apiConfiguration: self.apiConfiguration,
                callbacks: self.tfaHandler.callbacks,
                network: self.network,
                requestSigner: requestSigner,
                verifyApi: self.tfaHandler.verifyApi
            )
        )
        
        return accountApi
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
        ) -> CancellableToken {
        
        let cancellable = CancellableToken(request: nil)
        
        if errors.contains(status: ApiError.Status.forbidden, code: ApiError.Code.verificationRequired) {
            completion(.failure(.emailShouldBeVerified(walletId: walletId)))
        } else {
            errors.checkTFARequired(
                handler: self.tfaHandler,
                initiateTFA: initiateTFA,
                onCompletion: { [weak self] (tfaResult) in
                    switch tfaResult {
                        
                    case .success:
                        cancellable.request = self?.requestWallet(
                            walletId: walletId,
                            walletKDF: walletKDF,
                            request: request,
                            initiateTFA: false,
                            completion: completion
                            ).request
                        
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
    
    private func continueChangePassword(
        email uncheckedEmail: String,
        oldPassword: String,
        newPassword: String,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
        ) -> CancellableToken {
        
        let email = walletKDF.kdfParams.checkedEmail(uncheckedEmail)
        
        let walletId: String
        do {
            let walletIdData = try KeyPairBuilder.deriveWalletId(
                forEmail: email,
                password: oldPassword,
                walletKDF: walletKDF
            )
            walletId = walletIdData.hexadecimal()
        } catch {
            completion(.failed(.cannotDeriveEncodedWalletId))
            return CancellableToken(request: nil)
        }
        
        let cancelableToken = CancellableToken(request: nil)
        cancelableToken.request = self.requestWallet(
            walletId: walletId,
            walletKDF: walletKDF,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    completion(.failed(.walletDataError(error)))
                    
                case .success(let walletData):
                    cancelableToken.request = self?.continueChangePasswordForWalletData(
                        checkedEmail: email,
                        oldPassword: oldPassword,
                        newPassword: newPassword,
                        networkInfo: networkInfo,
                        walletKDF: walletKDF,
                        walletData: walletData,
                        completion: completion
                        ).request
                }
        }).request
        
        return cancelableToken
    }
    
    private func continueChangePasswordForWalletData(
        checkedEmail: String,
        oldPassword: String,
        newPassword: String,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        walletData: WalletDataModel,
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
        ) -> CancellableToken {
        
        guard let keychainData = walletData.keychainData.dataFromBase64 else {
            completion(.failed(.corruptedKeychainData))
            return CancellableToken(request: nil)
        }
        
        let signingKeyPair: ECDSA.KeyData
        do {
            signingKeyPair = try KeyPairBuilder.getKeyPair(
                forEmail: checkedEmail,
                password: oldPassword,
                keychainData: keychainData,
                walletKDF: walletKDF
            )
        } catch let error {
            completion(.failed(.cannotDeriveOldKeyFrom(error)))
            return CancellableToken(request: nil)
        }
        
        let accountApi = self.createAccountApi(signingKey: signingKeyPair)
        
        let cancellableToken = CancellableToken(request: nil)
        cancellableToken.request = accountApi.requestSigners(
            accountId: walletData.accountId,
            completion: { [weak self] (result) in
                
                let signers: [Account.Signer]
                
                switch result {
                    
                case .failure(let errors):
                    if errors.contains(status: ApiError.Status.notFound) {
                        signers = []
                    } else {
                        completion(.failed(.failedToRetriveSigners(errors)))
                        return
                    }
                    
                case .success(let responseSigners):
                    signers = responseSigners.signers
                }
                
                cancellableToken.request = self?.continueChangePasswordForSigners(
                    checkedEmail: checkedEmail,
                    newPassword: newPassword,
                    oldPassword: oldPassword,
                    oldKeyPair: signingKeyPair,
                    networkInfo: networkInfo,
                    walletKDF: walletKDF,
                    walletData: walletData,
                    signers: signers,
                    completion: completion
                    ).request
        }).request
        
        return cancellableToken
    }
    
    private func continueChangePasswordForSigners(
        checkedEmail: String,
        newPassword: String,
        oldPassword: String,
        oldKeyPair: ECDSA.KeyData,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        walletData: WalletDataModel,
        signers: [Account.Signer],
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
        ) -> CancellableToken {
        
        let sigs: [Account.Signer]
        
        if signers.count > 0 {
            sigs = signers
        } else {
            sigs = [Account.Signer(
                publicKey: walletData.accountId,
                weight: 0,
                signerIdentity: 0,
                signerTypeI: 0)
            ]
        }
        
        var cancellableToken = CancellableToken(request: nil)
        cancellableToken = self.updatePasswordFor(
            email: checkedEmail,
            signingPassword: oldPassword,
            walletId: walletData.walletId,
            originalAccountId: walletData.accountId,
            networkInfo: networkInfo,
            kdf: walletKDF.kdfParams,
            signingKeyPair: oldKeyPair,
            accountSigners: sigs,
            newPassword: newPassword,
            completion: { (result) in
                switch result {
                    
                case .failed(let error):
                    completion(.failed(error))
                    
                case .succeeded(let info, let walletData, let newKeyPair):
                    
                    completion(.succeeded(
                        updateInfo: info,
                        walletData: walletData,
                        newKeyPair: newKeyPair
                        )
                    )
                }
        })
        
        return cancellableToken
    }
    
    private func continueUpdatePassword(
        email: String,
        walletId: String,
        signingPassword: String,
        walletInfo: WalletInfoModel,
        signingKeyPair: ECDSA.KeyData,
        newKeyPair: ECDSA.KeyData,
        walletKDF: WalletKDFParams,
        sendDate: Date,
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
        ) -> CancellableToken {
        
        let request: UpdateWalletRequest
        
        do {
            let keyDataProvider = UnsafeRequestSignKeyDataProvider(keyPair: signingKeyPair)
            let requestSigner = RequestSigner(keyDataProvider: keyDataProvider)
            
            request = try self.requestBuilder.buildUpdateWalletRequest(
                walletId: walletId,
                walletInfo: walletInfo,
                requestSigner: requestSigner,
                sendDate: sendDate
            )
        } catch let error {
            completion(.failed(.failedToGenerateRequest(error)))
            return CancellableToken(request: nil)
        }
        
        return self.performUpdatePasswordRequest(
            request,
            email: email,
            walletId: walletId,
            signingPassword: signingPassword,
            walletInfo: walletInfo,
            newKeyPair: newKeyPair,
            walletKDF: walletKDF,
            initiateTFA: true,
            completion: completion
        )
    }
    
    private func performUpdatePasswordRequest(
        _ request: UpdateWalletRequest,
        email: String,
        walletId: String,
        signingPassword: String,
        walletInfo: WalletInfoModel,
        newKeyPair: ECDSA.KeyData,
        walletKDF: WalletKDFParams,
        initiateTFA: Bool,
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
        ) -> CancellableToken {
        
        var cancellableToken = CancellableToken(request: nil)
        cancellableToken = self.network.responseDataObject(
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
                        let meta = error.meta {
                        
                        if initiateTFA {
                            let onHandleTFAResult: (TFAResult) -> Void = { [weak self] tfaResult in
                                switch tfaResult {
                                    
                                case .success:
                                    cancellableToken.request = self?.performUpdatePasswordRequest(
                                        request,
                                        email: email,
                                        walletId: walletId,
                                        signingPassword: signingPassword,
                                        walletInfo: walletInfo,
                                        newKeyPair: newKeyPair,
                                        walletKDF: walletKDF,
                                        initiateTFA: false,
                                        completion: completion
                                        ).request
                                    
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
                    let walletData = WalletDataModel(
                        email: email,
                        accountId: walletInfo.attributes.accountId,
                        walletId: object.data.id,
                        type: object.data.type,
                        keychainData: walletInfo.attributes.keychainData,
                        walletKDF: walletKDF,
                        verified: object.data.attributes.verified
                    )
                    completion(.succeeded(
                        updateInfo: walletInfo,
                        walletData: walletData,
                        newKeyPair: newKeyPair
                        )
                    )
                }
        })
        
        return cancellableToken
    }
    
    private func getUnsafeMutablePointer<T: Any>(_ object: T) -> UnsafeMutablePointer<T> {
        let result = UnsafeMutablePointer<T>.allocate(capacity: 1)
        result[0] = object
        return result
    }
}

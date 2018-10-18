import Foundation
import TokenDWallet
import DLCryptoKit

extension KeyServerApi {
    
    // MARK: - Public -
    
    // MARK: Create Wallet
    
    /// Result model for `completion` block of `KeyServerApi.createWallet(...)`
    public enum CreateWalletRequestResult {
        
        /// Errors that may occur for `KeyServerApi.createWallet(...)`.
        public enum CreateWalletError: Swift.Error, LocalizedError {
            
            /// General create wallet error. Contains `ApiErrors` model.
            case createFailed(ApiErrors)
            
            /// Occurs if wallet with given email already exists.
            case emailAlreadyTaken
            
            /// Failed to generate key pair.
            case failedToGenerateKeyPair
            
            /// Failed to generate password factor key pair.
            case failedToGeneratePasswordFactorKeyPair
            
            /// Failed to generate recovery key pair.
            case failedToGenerateRecoveryKeyPair
            
            /// Failed to build request model.
            case failedToGenerateRequest(Swift.Error)
            
            /// Failed to build `WalletInfoModel` model.
            case registrationInfoError(WalletInfoBuilder.CreateResult.CreateError)
            
            /// Failed to get wallet KDF params.
            case walletKDFError(RequestDefaultKDFResult.RequestError)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .createFailed(let errors):
                    return errors.localizedDescription
                case .emailAlreadyTaken:
                    return "Email already taken"
                case .failedToGenerateKeyPair:
                    return "Failed to generate key pair"
                case .failedToGeneratePasswordFactorKeyPair:
                    return "Failed to generate password factor key pair"
                case .failedToGenerateRecoveryKeyPair:
                    return "Failed to generate recovery key pair"
                case .failedToGenerateRequest(let error):
                    return error.localizedDescription
                case .registrationInfoError(let error):
                    return error.localizedDescription
                case .walletKDFError(let error):
                    return error.localizedDescription
                }
            }
        }
        
        /// Case of failed create wallet operation with `CreateWalletRequestResult.CreateWalletError` model
        case failure(CreateWalletError)
        
        /// Case of successful response from api with `WalletInfoModel`, `WalletDataModel`,
        /// private `ECDSA.KeyData` and recovery `ECDSA.KeyData` models
        case success(
            registrationInfo: WalletInfoModel,
            walletData: WalletDataModel,
            keyPair: ECDSA.KeyData,
            recoveryKey: ECDSA.KeyData
        )
    }
    
    /// Method sends request to create wallet and register it within Key Server.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.CreateWalletRequestResult`
    /// - Parameters:
    ///   - email: Email of associated wallet.
    ///   - password: Password to cypher private key.
    ///   - referrerAccountId: Referrer account id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.LoginRequestResult`
    public func createWallet(
        email: String,
        password: String,
        referrerAccountId: String? = nil,
        completion: @escaping (_ result: CreateWalletRequestResult) -> Void
        ) {
        
        self.requestDefaultKDF(completion: { [weak self] result in
            switch result {
                
            case .success(let kdfParams):
                self?.continueCreateWalletForKDF(
                    email: email,
                    password: password,
                    referrerAccountId: referrerAccountId,
                    kdfParams: kdfParams,
                    completion: completion
                )
                
            case .failure(let error):
                completion(.failure(.walletKDFError(error)))
            }
        })
    }
    
    // MARK: Verify email
    
    /// Result model for `completion` block of `KeyServerApi.verifyEmail(...)`
    public enum VerifyEmailResult {
        
        /// Errors that may occur for `KeyServerApi.verifyEmail(...)`.
        public enum VerifyEmailError: Swift.Error, LocalizedError {
            
            /// Failed to build request model.
            case failedToGenerateRequest(Swift.Error)
            
            /// Verify email request failed. Contains `ApiErrors`.
            case verificationFailed(ApiErrors)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                    
                case .failedToGenerateRequest(let error):
                    return error.localizedDescription
                    
                case .verificationFailed(let errors):
                    return errors.localizedDescription
                }
            }
        }
        
        /// Case of successful response from api
        case success
        
        /// Case of failed verify email operation with `VerifyEmailResult.VerifyEmailError` model
        case failure(VerifyEmailError)
    }
    
    /// Method sends request to verify email.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.VerifyEmailResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - token: Verify token.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.VerifyEmailResult`
    public func verifyEmail(
        walletId: String,
        token: String,
        completion: @escaping (_ result: VerifyEmailResult) -> Void
        ) {
        
        let request: VerifyEmailRequest
        do {
            request = try self.requestBuilder.buildVerifyEmailRequest(walletId: walletId, token: token)
        } catch let error {
            completion(.failure(.failedToGenerateRequest(error)))
            return
        }
        
        self.network.responseDataEmpty(
            url: request.url,
            method: request.method,
            bodyData: request.verifyData,
            completion: { (result) in
                
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(.verificationFailed(errors)))
                    
                case .success:
                    completion(.success)
                }
        })
    }
    
    // MARK: Resend email
    
    /// Result model for `completion` block of `KeyServerApi.resendEmail(...)`
    public enum ResendEmailResult {
        
        /// Case of successful response from api
        case success
        
        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to resend verifivation email.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.ResendEmailResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.ResendEmailResult`
    public func resendEmail(
        walletId: String,
        completion: @escaping (_ result: ResendEmailResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildResendEmailRequest(walletId: walletId)
        
        self.network.responseDataEmpty(
            url: request.url,
            method: request.method,
            completion: { (result) in
                
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors))
                    
                case .success:
                    completion(.success)
                }
        })
    }
    
    // MARK: - Private -
    
    private func continueCreateWalletForKDF(
        email: String,
        password: String,
        referrerAccountId: String?,
        kdfParams: KDFParams,
        completion: @escaping (_ result: CreateWalletRequestResult) -> Void
        ) {
        
        guard let keyPair = try? ECDSA.KeyData() else {
            return completion(.failure(.failedToGenerateKeyPair))
        }
        
        guard let recoveryKeyPair = try? ECDSA.KeyData() else {
            return completion(.failure(.failedToGenerateRecoveryKeyPair))
        }
        
        guard let passwordFactorKey = try? ECDSA.KeyData() else {
            return completion(.failure(.failedToGeneratePasswordFactorKeyPair))
        }
        
        let keychainParams = WalletInfoBuilder.KeychainParams(
            newKeyPair: keyPair,
            recoveryKeyPair: recoveryKeyPair,
            passwordFactorKey: passwordFactorKey
        )
        
        let createRegistrationInfoResult = WalletInfoBuilder.createWalletInfo(
            email: email,
            password: password,
            kdfParams: kdfParams,
            keychainParams: keychainParams,
            transaction: nil,
            referrerAccountId: referrerAccountId
        )
        
        switch createRegistrationInfoResult {
            
        case .failed(let error):
            completion(.failure(.registrationInfoError(error)))
            
        case .succeeded(let walletInfo):
            let request: CreateWalletRequest
            do {
                request = try self.requestBuilder.buildCreateWalletRequest(walletInfo: walletInfo)
            } catch let error {
                completion(.failure(.failedToGenerateRequest(error)))
                return
            }
            
            self.network.responseDataObject(
                ApiDataResponse<WalletInfoResponse>.self,
                url: request.url,
                method: request.method,
                bodyData: request.registrationInfoData,
                completion: { (result) in
                    
                    switch result {
                        
                    case .failure(let errors):
                        if errors.contains(status: ApiError.Status.conflict) {
                            completion(.failure(.emailAlreadyTaken))
                        } else {
                            completion(.failure(.createFailed(errors)))
                        }
                        
                    case .success(let response):
                        let walletKDF = WalletKDFParams(
                            kdfParams: kdfParams,
                            salt: keychainParams.newKeyPairKeychainSalt
                        )
                        
                        let walletData = WalletDataModel(
                            email: email,
                            accountId: walletInfo.attributes.accountId,
                            walletId: response.data.id,
                            type: response.data.type,
                            keychainData: walletInfo.attributes.keychainData,
                            walletKDF: walletKDF,
                            verified: response.data.attributes.verified
                        )
                        
                        completion(.success(
                            registrationInfo: walletInfo,
                            walletData: walletData,
                            keyPair: keychainParams.newKeyPair,
                            recoveryKey: keychainParams.recoveryKeyPair
                            )
                        )
                    }
            })
        }
    }
}

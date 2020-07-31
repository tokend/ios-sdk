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

            /// Failed to build request model.
            case failedToGenerateRequest(Swift.Error)

            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .createFailed(let errors):
                    return errors.localizedDescription
                case .emailAlreadyTaken:
                    return "Email already taken"
                case .failedToGenerateRequest(let error):
                    return error.localizedDescription
                }
            }
        }
        
        /// Case of failed create wallet operation with `CreateWalletRequestResult.CreateWalletError` model
        case failure(CreateWalletError)
        
        /// Case of successful response from api with `WalletInfoModel`, `WalletDataModel`,
        /// private `ECDSA.KeyData` and recovery `ECDSA.KeyData` models
        case success(WalletInfoResponse)
    }
    
    /// Method sends request to create wallet and register it within Key Server.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.CreateWalletRequestResult`
    /// - Parameters:
    ///   - email: Email of associated wallet.
    ///   - password: Password to cypher private key.
    ///   - keyPair: Wallet key pair. If not provided will generate random.
    ///   - recoveryKeyPair: Wallet recovery key pair. If not provided will generate random.
    ///   - passwordFactorKeyPair: Password tfa factor key pair. If not provided will generate random.
    ///   - referrerAccountId: Referrer account id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.LoginRequestResult`
    public func createWallet(
        walletInfo: WalletInfoModel,
        completion: @escaping (_ result: CreateWalletRequestResult) -> Void
        ) {
        
        let request: CreateWalletRequest
        do {
            request = try self.requestBuilder.buildCreateWalletRequest(
                walletInfo: walletInfo
            )
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
                    completion(.success(response.data))
                }
        })
    }
    
    // MARK: Verify email

    @available(*, unavailable, renamed: "VerifyWalletResult")
    public typealias VerifyEmailResult = VerifyWalletResult
    
    /// Result model for `completion` block of `KeyServerApi.verifyWallet(...)`
    public enum VerifyWalletResult {

        @available(*, unavailable, renamed: "VerifyWalletError")
        public typealias VerifyEmailError = VerifyWalletError
        /// Errors that may occur for `KeyServerApi.verifyWallet(...)`.
        public enum VerifyWalletError: Swift.Error, LocalizedError {
            
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
        
        /// Case of failed verify email operation with `VerifyWalletResult.VerifyWalletError` model
        case failure(VerifyWalletError)
    }

    @available(*, unavailable, renamed: "verifyWallet")
    public func verifyEmail(
        walletId: String,
        token: String,
        completion: @escaping (_ result: VerifyWalletResult) -> Void
    ) {

        verifyWallet(
            walletId: walletId,
            token: token,
            completion: completion
        )
    }
    /// Method sends request to verify email.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.VerifyWalletResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - token: Verify token.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.VerifyWalletResult`
    public func verifyWallet(
        walletId: String,
        token: String,
        completion: @escaping (_ result: VerifyWalletResult) -> Void
        ) {
        
        let request: VerifyWalletRequest
        do {
            request = try self.requestBuilder.buildVerifyWalletRequest(walletId: walletId, token: token)
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
}

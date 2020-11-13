import Foundation
import TokenDWallet
import DLCryptoKit

// MARK: - KeyServerApi

public extension KeyServerApi {

    /// Method to create `AccountsApi` instance.
    /// - Parameters:
    ///   - signingKey: Private key pair to sign api requests.
    /// - Returns: `AccountsApi` instance.
    @available(*, deprecated)
    func createAccountsApiV3(
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
    
    /// Method sends request to create wallet and register it within Key Server.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.CreateWalletRequestResult`
    /// - Parameters:
    ///   - walletInfo: Wallet info.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.LoginRequestResult`
    @available(*, deprecated, renamed: "createWalletV2")
    func createWallet(
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

    @available(*, deprecated, renamed: "performUpdatePasswordV2Request")
    func performUpdatePasswordRequest(
        email: String,
        walletId: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        walletInfo: WalletInfoModel,
        requestSigner: JSONAPI.RequestSignerProtocol,
        completion: @escaping (_ result: Result<WalletInfoResponse, Swift.Error>) -> Void
        ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildUpdateWalletRequest(
            walletId: walletId,
            walletInfo: walletInfo,
            requestSigner: requestSigner,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.performPutWalletRequest(
                    request,
                    login: email,
                    signingPassword: signingPassword,
                    walletKDF: walletKDF,
                    initiateTFA: true,
                    completion: completion
                )
        })

        return cancelable
    }

    @available(*, deprecated, renamed: "VerifyWalletResult")
    typealias VerifyEmailResult = VerifyWalletResult

    @available(*, deprecated, renamed: "verifyWallet")
    func verifyEmail(
        walletId: String,
        token: String,
        completion: @escaping (_ result: VerifyEmailResult) -> Void
    ) {

        verifyWallet(
            walletId: walletId,
            token: token,
            completion: { (result) in

                switch result {

                case .success:
                    completion(.success)

                case .failure(let error):
                    completion(.failure(.swiftError(error)))
                }
            }
        )
    }

    @available(*, deprecated, renamed: "ResendVerificationCodeResult")
    typealias ResendEmailResult = ResendVerificationCodeResult

    @available(*, deprecated, renamed: "resendVerificationCode")
    func resendEmail(
        walletId: String,
        completion: @escaping (_ result: ResendEmailResult) -> Void
    ) {

        resendVerificationCode(
            walletId: walletId,
            completion: { (result) in

                switch result {

                case .failure(let error):
                    completion(.failure(error))

                case .success:
                    completion(.success)
                }
            }
        )
    }

    @available(*, deprecated, renamed: "PutWalletError")
    typealias UpdatePasswordV2Error = PutWalletError

    /// Result model for `completion` block of `KeyServerApi.updatePasswordFor(...)`
    @available(*, deprecated, renamed: "PutWalletError")
    enum UpdatePasswordResult {

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

            case swiftError(Swift.Error)

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

                case .swiftError(let error):
                    return error.localizedDescription
                }
            }
        }

        /// Case of failed update password operation with `UpdatePasswordResult.UpdateError` model
        case failed(UpdateError)

        /// Case of successful update password operation
        /// with `WalletInfoModel`, `WalletDataModel` and new private `ECDSA.KeyData` models
        case succeeded(WalletInfoResponse)
    }

    @available(*, deprecated, renamed: "putWallet")
    func performUpdatePasswordV2Request(
        login: String,
        walletId: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        walletInfo: WalletInfoModelV2,
        requestSigner: JSONAPI.RequestSignerProtocol,
        completion: @escaping (_ result: UpdatePasswordResult) -> Void
    ) -> Cancelable {

        putWallet(
            login: login,
            walletId: walletId,
            signingPassword: signingPassword,
            walletKDF: walletKDF,
            walletInfo: walletInfo,
            requestSigner: requestSigner,
            completion: { (result) in

                switch result {

                case .success(let response):
                    completion(.succeeded(response))

                case .failure(let error):
                    completion(.failed(.swiftError(error)))
                }
            }
        )
    }

    @available(*, deprecated, renamed: "postWallet")
    func performPostWalletV2Request(
        walletId: String,
        walletInfo: WalletInfoModelV2,
        completion: @escaping (_ result: Result<WalletInfoResponse, Swift.Error>) -> Void
    ) {

        postWallet(
            walletId: walletId,
            walletInfo: walletInfo,
            completion: completion
        )
    }

    /// Result model for `completion` block of `KeyServerApi.requestWallet(...)`
    @available(*, deprecated)
    enum RequestWalletResult {

        /// Errors that may occur for `KeyServerApi.requestWallet(...)`.
        public enum RequestWalletError: Swift.Error, LocalizedError {

            /// Wallet is not verified.
            @available(*, unavailable, renamed: "walletShouldBeVerified")
            case emailShouldBeVerified(walletId: String)
            case walletShouldBeVerified(walletId: String)

            /// TFA failed.
            case tfaFailed

            /// Unrecognized error. Contains `ApiErrors` model.
            case unknown(ApiErrors)

            /// Input password is wrong.
            case wrongPassword

            case swiftError(Swift.Error)

            // MARK: - Swift.Error

            public var errorDescription: String? {
                switch self {
                case .emailShouldBeVerified,
                     .walletShouldBeVerified:
                    return "Wallet should be verified"
                case .tfaFailed:
                    return "TFA failed"
                case .unknown(let errors):
                    return errors.localizedDescription
                case .wrongPassword:
                    return "Wrong password"
                case .swiftError(let error):
                    return error.localizedDescription
                }
            }
        }

        /// Case of failed response from api with `RequestWalletResult.RequestWalletError` model
        case failure(RequestWalletError)

        /// Case of successful response from api with `WalletDataModel` model
        case success(walletData: WalletDataModel)
    }

    @available(*, deprecated, renamed: "getWallet")
    @discardableResult
    func requestWallet(
        walletId: String,
        walletKDF: WalletKDFParams,
        completion: @escaping (_ result: RequestWalletResult) -> Void
        ) -> Cancelable {

        getWallet(
            walletId: walletId,
            walletKDF: walletKDF,
            completion: { (result) in

                switch result {

                case .success(let data):
                    completion(.success(walletData: data))

                case .failure(let error):
                    completion(.failure(.swiftError(error)))
                }
            }
        )
    }

    /// Result model for `completion` block of `KeyServerApi.requestWalletKDF(...)`
    @available(*, deprecated)
    enum RequestWalletKDFResult {

        /// Errors that may occur for `KeyServerApi.requestWalletKDF(...)`
        public enum RequestError: Swift.Error, LocalizedError {

            /// KDF params not found for given login.
            @available(*, deprecated, renamed: "loginNotFound")
            case emailNotFound
            case loginNotFound

            /// Unrecognized error. Contains `ApiErrors`
            case unknown(ApiErrors)

            case swiftError(Swift.Error)

            // MARK: - Swift.Error

            public var errorDescription: String? {
                switch self {
                case .emailNotFound,
                     .loginNotFound:
                    return "KDF for login not found"
                case .unknown(let errors):
                    return errors.localizedDescription

                case .swiftError(let error):
                    return error.localizedDescription
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
    ///   - login: Login of associated wallet.
    ///   - isRecovery: Indicates whether is recovery wallet data should be fetched. Default is **false**.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletKDFResult`
    /// - Returns: `Cancelable`
    @available(*, deprecated, renamed: "getWalletKDF")
    @discardableResult
    func requestWalletKDF(
        login: String,
        isRecovery: Bool = false,
        completion: @escaping (_ result: RequestWalletKDFResult) -> Void
        ) -> Cancelable {

        getWalletKDF(
            login: login,
            isRecovery: isRecovery,
            completion: { (result) in

                switch result {

                case .success(let kdf):
                    completion(.success(walletKDF: kdf))

                case .failure(let error):
                    completion(.failure(.swiftError(error)))
                }
            }
        )
    }

    /// Result model for `completion` block of `KeyServerApi.requestDefaultKDF(...)`
    @available(*, deprecated)
    enum RequestDefaultKDFResult {

        /// Errors that may occur for `KeyServerApi.requestDefaultKDF(...)`
        public enum RequestError: Swift.Error, LocalizedError {

            /// Unrecognized error. Contains `ApiErrors`
            case unknown(ApiErrors)

            case swiftError(Swift.Error)

            // MARK: - Swift.Error

            public var errorDescription: String? {
                switch self {
                case .unknown(let errors):
                    return errors.localizedDescription

                case .swiftError(let error):
                    return error.localizedDescription
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
    @available(*, deprecated, renamed: "getDefaultKDFParams")
    func requestDefaultKDF(
        completion: @escaping (_ result: RequestDefaultKDFResult) -> Void
        ) {

        getDefaultKDFParams(
            completion: { (result) in

                switch result {

                case .success(let kdf):
                    completion(.success(kdfParams: kdf))

                case .failure(let error):
                    completion(.failure(.swiftError(error)))
                }
            }
        )
    }

    /// Result model for `completion` block of `KeyServerApi.requestDefaultSignerRoleId(...)`
    @available(*, deprecated)
    enum RequestDefaultSignerRoleIdResult {

        /// Case of failed response from api with `ApiErrors` model
        case failure(Swift.Error)

        /// Case of successful response from api with `DefaultSignerRoleIdResponse` model
        case success(DefaultSignerRoleIdResponse)
    }
    /// Method sends request to get system info.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.DefaultSignerRoleIdResponse`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.DefaultSignerRoleIdResponse`
    @available(*, deprecated, renamed: "getDefaultSignerRoleId")
    func requestDefaultSignerRoleId(
        completion: @escaping (_ result: RequestDefaultSignerRoleIdResult) -> Void
        ) {

        getDefaultSignerRoleId(
            completion: { (result) in

                switch result {

                case .success(let response):
                    completion(.success(response))

                case .failure(let errors):
                    completion(.failure(errors))
                }
            }
        )
    }

    /// Result model for `completion` block of `KeyServerApi.verifyWallet(...)`
    @available(*, deprecated)
    enum VerifyWalletResult {

        /// Errors that may occur for `KeyServerApi.verifyWallet(...)`.
        @available(*, deprecated)
        public enum VerifyWalletError: Swift.Error, LocalizedError {

            /// Failed to build request model.
            case failedToGenerateRequest(Swift.Error)

            /// Verify wallet request failed. Contains `ApiErrors`.
            case verificationFailed(ApiErrors)

            case swiftError(Swift.Error)

            // MARK: - Swift.Error

            public var errorDescription: String? {
                switch self {

                case .failedToGenerateRequest(let error):
                    return error.localizedDescription

                case .verificationFailed(let errors):
                    return errors.localizedDescription

                case .swiftError(let error):
                    return error.localizedDescription
                }
            }
        }

        /// Case of successful response from api
        case success

        /// Case of failed verify wallet operation with `VerifyWalletResult.VerifyWalletError` model
        case failure(VerifyWalletError)
    }

    /// Result model for `completion` block of `KeyServerApi.createWallet(...)`
    @available(*, deprecated)
    enum CreateWalletRequestResult {

        /// Errors that may occur for `KeyServerApi.createWallet(...)`.
        @available(*, deprecated)
        public enum CreateWalletError: Swift.Error, LocalizedError {

            /// General create wallet error. Contains `ApiErrors` model.
            case createFailed(ApiErrors)

            /// Occurs if wallet with given login already exists.
            @available(*, deprecated, renamed: "loginAlreadyTaken")
            case emailAlreadyTaken
            case loginAlreadyTaken

            /// Failed to build request model.
            case failedToGenerateRequest(Swift.Error)

            // MARK: - Swift.Error

            public var errorDescription: String? {
                switch self {
                case .createFailed(let errors):
                    return errors.localizedDescription
                case .emailAlreadyTaken,
                     .loginAlreadyTaken:
                    return "Login already taken"
                case .failedToGenerateRequest(let error):
                    return error.localizedDescription
                }
            }
        }

        /// Case of failed create wallet operation with `CreateWalletRequestResult.CreateWalletError` model
        case failure(CreateWalletError)

        /// Case of successful response from api
        case success(WalletInfoResponse)
    }

    /// Result model for `completion` block of `KeyServerApi.resendVerificationCode(...)`
    @available(*, deprecated)
    enum ResendVerificationCodeResult {

        /// Case of successful response from api
        case success

        /// Case of failed response from api with `ApiErrors` model
        case failure(Swift.Error)
    }

    @available(*, deprecated)
    /// Result model for `completion` block of `KeyServerApi.requestWalletVerificationState(...)`
    enum RequestWalletVerificationStateResult {

        /// Case of unverified wallet status
        case unverified

        /// Case of verified wallet status
        case verified

        // Case of requets failure
        case failure(Swift.Error)
    }

    /// Method sends request to check wallet's verification status.
    /// The result of request will be fetched in `completion` block as
    /// `KeyServerApi.RequestWalletVerificationStateResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletVerificationStateResult`
    @available(*, deprecated, renamed: "getWalletVerificationState")
    func requestWalletVerificationState(
        walletId: String,
        completion: @escaping (_ result: RequestWalletVerificationStateResult) -> Void
        ) {

        getWalletVerificationState(
            walletId: walletId,
            completion: { (result) in

                switch result {

                case .failure(let error):
                    completion(.failure(error))

                case .success(let state):
                    switch state {

                    case .unverified:
                        completion(.unverified)

                    case .verified:
                        completion(.verified)
                    }
                }
            }
        )
    }

    /// Result model for `completion` block of `KeyServerApi.loginWith(...)`
    @available(*, deprecated)
    enum LoginRequestResult {

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

            case swiftError(Swift.Error)

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
                case .swiftError(let error):
                    return error.localizedDescription
                }
            }
        }

        /// Case of successful response from api with `WalletDataModel` and `ECDSA.KeyData` models
        case success(walletData: WalletDataModel, keyPairs: [ECDSA.KeyData])

        /// Case of failed response from api with `KeyServerApi.LoginRequestResult.LoginError` model
        case failure(LoginError)
    }
}

@available(*, deprecated)
extension KeyServerApi.VerifyWalletResult {

    @available(*, unavailable, renamed: "VerifyWalletError")
    public typealias VerifyEmailError = VerifyWalletError
}

// MARK: - KeyServerApiRequestBuilder

extension KeyServerApiRequestBuilder {

    @available(*, unavailable, renamed: "buildResendVerificationCodeRequest")
    public func buildResendEmailRequest(
        walletId: String
    ) -> ResendVerificationCodeRequest {

        return buildResendVerificationCodeRequest(
            walletId: walletId
        )
    }

    @available(*, deprecated, renamed: "buildVerifyWalletRequest")
    public func buildVerifyEmailRequest(
        walletId: String,
        token: String
    ) throws -> VerifyWalletRequest {

        try buildVerifyWalletRequest(
            walletId: walletId,
            token: token
        )
    }

    /// Builds request to verify wallet.
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - token: Verification token.
    /// - Returns: `VerifyWalletRequest` model.
    @available(*, deprecated, renamed: "buildVerifyWalletV2Request")
    public func buildVerifyWalletRequest(
        walletId: String,
        token: String
        ) throws -> VerifyWalletRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets/\(walletId)/verification")

        let attributes = WalletVerification.Attributes(token: token)
        let verification = WalletVerification(attributes: attributes)
        let verifyData = ApiDataRequest<WalletVerification, WalletInfoModel.Include>(data: verification)
        let verifyDataEncoded = try verifyData.encode()

        let request = VerifyWalletRequest(
            url: url,
            method: .put,
            verifyData: verifyDataEncoded
        )

        return request
    }

    /// Builds request to fetch wallet KDF params from api.
    /// - Parameters:
    ///   - walletInfo: Wallet info model.
    /// - Returns: `CreateWalletRequest` model.
    @available(*, deprecated, renamed: "buildCreateWalletV2Request")
    public func buildCreateWalletRequest(
        walletInfo: WalletInfoModel
        ) throws -> CreateWalletRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/walletsPath

        let registrationInfoData = ApiDataRequest<WalletInfoModel.WalletInfoData, WalletInfoModel.Include>(
            data: walletInfo.data,
            included: walletInfo.included
        )
        let registrationInfoDataEncoded = try registrationInfoData.encode()

        let request = CreateWalletRequest(
            url: url,
            method: .post,
            parametersEncoding: .json,
            registrationInfoData: registrationInfoDataEncoded
        )

        return request
    }

    /// Builds request to update wallet. Used to update password.
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - walletInfo: Wallet info model.
    ///   - requestSigner: Entity that signs request.
    ///   - sendDate: Request send date.
    ///   - completion: Returns `UpdateWalletRequest` or nil.
    @available(*, deprecated, renamed: "buildUpdateWalletV2Request")
    public func buildUpdateWalletRequest(
        walletId: String,
        walletInfo: WalletInfoModel,
        requestSigner: JSONAPI.RequestSignerProtocol,
        sendDate: Date = Date(),
        completion: @escaping (UpdateWalletRequest?) -> Void
        ) {

        let baseUrl = self.apiConfiguration.urlString
        let path = /walletsPath/walletId
        let url = baseUrl/path
        let method: RequestMethod = .put

        let walletData = ApiDataRequest<WalletInfoModel.WalletInfoData, WalletInfoModel.Include>(
            data: walletInfo.data,
            included: walletInfo.included
        )
        guard let walletInfoDataEncoded = try? walletData.encode() else {
            completion(nil)
            return
        }

        let requestSignModel = JSONAPI.RequestSignParametersModel(
            baseUrl: baseUrl,
            path: path,
            method: method,
            queryItems: [],
            bodyParameters: nil,
            headers: nil,
            sendDate: sendDate,
            network: self.network
        )

        requestSigner.sign(
            request: requestSignModel,
            completion: { (signedHeaders) in
                guard let signedHeaders = signedHeaders else {
                    completion(nil)
                    return
                }

                let request = UpdateWalletRequest(
                    url: url,
                    method: method,
                    parametersEncoding: .json,
                    registrationInfoData: walletInfoDataEncoded,
                    signedHeaders: signedHeaders
                )
                completion(request)
        })
    }

    @available(*, deprecated, renamed: "buildPutWalletRequest")
    func buildUpdateWalletV2Request(
        walletId: String,
        walletInfo: WalletInfoModelV2,
        requestSigner: JSONAPI.RequestSignerProtocol,
        sendDate: Date = Date(),
        completion: @escaping (UpdateWalletRequest?) -> Void
        ) {

        buildPutWalletRequest(
            walletId: walletId,
            walletInfo: walletInfo,
            requestSigner: requestSigner,
            sendDate: sendDate,
            completion: completion
        )
    }
}

@available(*, unavailable, renamed: "ResendVerificationCodeRequest")
public typealias ResendEmailRequest = ResendVerificationCodeRequest

@available(*, unavailable, renamed: "VerifyWalletRequest")
public typealias VerifyEmailRequest = VerifyWalletRequest

@available(*, unavailable, renamed: "WalletVerification")
public typealias EmailVerification = WalletVerification

@available(*, deprecated, renamed: "PutWalletRequest")
public typealias UpdateWalletRequest = PutWalletRequest

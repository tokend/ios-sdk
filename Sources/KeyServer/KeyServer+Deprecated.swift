import Foundation
import TokenDWallet
import DLCryptoKit

extension KeyServerApi {

    /// Method to create `AccountsApi` instance.
    /// - Parameters:
    ///   - signingKey: Private key pair to sign api requests.
    /// - Returns: `AccountsApi` instance.
    @available(*, deprecated)
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
    
    /// Method sends request to create wallet and register it within Key Server.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.CreateWalletRequestResult`
    /// - Parameters:
    ///   - walletInfo: Wallet info.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.LoginRequestResult`
    @available(*, deprecated, renamed: "createWalletV2")
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

    @available(*, deprecated, renamed: "performUpdatePasswordV2Request")
    public func performUpdatePasswordRequest(
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

                cancelable.cancelable = self?.performUpdatePasswordRequest(
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

    @available(*, unavailable, renamed: "VerifyWalletResult")
    public typealias VerifyEmailResult = VerifyWalletResult

    @available(*, unavailable, renamed: "verifyWallet")
    public func verifyEmail(
        walletId: String,
        token: String,
        completion: @escaping (_ result: VerifyEmailResult) -> Void
    ) {

        verifyWallet(
            walletId: walletId,
            token: token,
            completion: completion
        )
    }

    @available(*, unavailable, renamed: "ResendVerificationCodeResult")
    public typealias ResendEmailResult = ResendVerificationCodeResult

    @available(*, unavailable, renamed: "resendVerificationCode")
    public func resendEmail(
        walletId: String,
        completion: @escaping (_ result: ResendEmailResult) -> Void
    ) {

        resendVerificationCode(
            walletId: walletId,
            completion: completion
        )
    }
}

extension KeyServerApi.VerifyWalletResult {

    @available(*, unavailable, renamed: "VerifyWalletError")
    public typealias VerifyEmailError = VerifyWalletError
}

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
}

@available(*, unavailable, renamed: "ResendVerificationCodeRequest")
public typealias ResendEmailRequest = ResendVerificationCodeRequest

@available(*, unavailable, renamed: "VerifyWalletRequest")
public typealias VerifyEmailRequest = VerifyWalletRequest

@available(*, unavailable, renamed: "WalletVerification")
public typealias EmailVerification = WalletVerification

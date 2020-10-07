import Foundation

/// Class provides functionality that allows to build requests
/// which are used to communicate with Key Server.
public class KeyServerApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let apiConfiguration: ApiConfiguration
    public let network: JSONAPI.NetworkProtocol
    
    private let keyValue = "key_value"
    private let signerRoleDefault = "signer_role:default"
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        network: JSONAPI.NetworkProtocol
        ) {
        
        self.apiConfiguration = apiConfiguration
        self.network = network
    }
    
    // MARK: - Public
    
    /// Builds request to fetch KDF params from api.
    /// - Returns: `GetKDFParamsRequest` model.
    public func buildGetKDFParamsRequest() -> GetKDFParamsRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("kdf")
        
        let request = GetKDFParamsRequest(
            url: url,
            method: .get,
            parametersEncoding: .url
        )
        
        return request
    }

    @available(*, deprecated, renamed: "buildCreateWalletV2Request")
    /// Builds request to fetch wallet KDF params from api.
    /// - Parameters:
    ///   - walletInfo: Wallet info model.
    /// - Returns: `CreateWalletRequest` model.
    public func buildCreateWalletRequest(
        walletInfo: WalletInfoModel
        ) throws -> CreateWalletRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets")
        
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

    /// Builds request to fetch wallet KDF params from api.
    /// - Parameters:
    ///   - walletInfo: Wallet info model.
    /// - Returns: `CreateWalletRequest` model.
    public func buildCreateWalletV2Request(
        walletInfo: WalletInfoModelV2
        ) throws -> CreateWalletRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets")

        let registrationInfoData = ApiDataRequest<WalletInfoModelV2.WalletInfoData, WalletInfoModelV2.Include>(
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

    @available(*, deprecated, renamed: "buildUpdateWalletV2Request")
    /// Builds request to update wallet. Used to update password.
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - walletInfo: Wallet info model.
    ///   - requestSigner: Entity that signs request.
    ///   - sendDate: Request send date.
    ///   - completion: Returns `UpdateWalletRequest` or nil.
    public func buildUpdateWalletRequest(
        walletId: String,
        walletInfo: WalletInfoModel,
        requestSigner: JSONAPI.RequestSignerProtocol,
        sendDate: Date = Date(),
        completion: @escaping (UpdateWalletRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let path = /"wallets"/walletId
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

    /// Builds request to update wallet. Used to update password.
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - walletInfo: Wallet info model.
    ///   - requestSigner: Entity that signs request.
    ///   - sendDate: Request send date.
    ///   - completion: Returns `UpdateWalletRequest` or nil.
    public func buildUpdateWalletV2Request(
        walletId: String,
        walletInfo: WalletInfoModelV2,
        requestSigner: JSONAPI.RequestSignerProtocol,
        sendDate: Date = Date(),
        completion: @escaping (UpdateWalletRequest?) -> Void
        ) {

        let baseUrl = self.apiConfiguration.urlString
        let path = /"wallets"/walletId
        let url = baseUrl/path
        let method: RequestMethod = .put

        let walletData = ApiDataRequest<WalletInfoModelV2.WalletInfoData, WalletInfoModelV2.Include>(
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

    @available(*, unavailable, renamed: "buildVerifyWalletRequest")
    public func buildVerifyEmailRequest(
        walletId: String,
        token: String
    ) throws -> VerifyWalletRequest {

        try buildVerifyWalletRequest(
            walletId: walletId,
            token: token
        )
    }

    @available(*, deprecated, renamed: "buildVerifyWalletV2Request")
    /// Builds request to verify wallet.
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - token: Verification token.
    /// - Returns: `VerifyWalletRequest` model.
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

    /// Builds request to verify wallet.
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - token: Verification token.
    /// - Returns: `VerifyWalletRequest` model.
    public func buildVerifyWalletV2Request(
        walletId: String,
        token: String
        ) throws -> VerifyWalletRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets/\(walletId)/verification")

        let attributes = WalletVerification.Attributes(token: token)
        let verification = WalletVerification(attributes: attributes)
        let verifyData = ApiDataRequest<WalletVerification, WalletInfoModelV2.Include>(data: verification)
        let verifyDataEncoded = try verifyData.encode()

        let request = VerifyWalletRequest(
            url: url,
            method: .put,
            verifyData: verifyDataEncoded
        )

        return request
    }

    @available(*, unavailable, renamed: "buildResendVerificationCodeRequest")
    public func buildResendEmailRequest(
        walletId: String
    ) -> ResendVerificationCodeRequest {

        return buildResendVerificationCodeRequest(
            walletId: walletId
        )
    }
    
    /// Builds request to resend verification code.
    /// - Parameters:
    ///   - walletId: Wallet id.
    /// - Returns: `ResendVerificationCodeRequest` model.
    public func buildResendVerificationCodeRequest(
        walletId: String
        ) -> ResendVerificationCodeRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets/\(walletId)/verification")
        
        let request = ResendVerificationCodeRequest(
            url: url,
            method: .post
        )
        
        return request
    }
    
    /// Builds request to fetch wallet KDF params.
    /// - Parameters:
    ///   - login: Login associated with wallet.
    ///   - isRecovery: Flag to indicate whether is recovery keychain data is requested.
    /// - Returns: `GetWalletKDFRequest` model.
    public func buildGetWalletKDFRequest(
        login: String,
        isRecovery: Bool
        ) -> GetWalletKDFRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets").addPath("kdf")
        
        var parameters = RequestParameters()
        parameters["email"] = login
        if isRecovery {
            parameters["is_recovery"] = "true"
        }
        
        let request = GetWalletKDFRequest(
            url: url,
            method: .get,
            parameters: parameters,
            parametersEncoding: .url
        )
        
        return request
    }
    
    /// Builds request to fetch wallet data.
    /// - Parameters:
    ///   - walletId: Wallet id.
    /// - Returns: `GetWalletRequest` model.
    public func buildGetWalletRequest(
        walletId: String
        ) -> GetWalletRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets").addPath(walletId)
        
        let request = GetWalletRequest(
            url: url,
            method: .get
        )
        
        return request
    }
    
    /// Builds request to fetch system info from api.
    /// - Returns: `SystemInfoRequest` model.
    public func buildRequestSystemInfoRequest() -> SystemInfoRequest {
        let baseUrl = self.apiConfiguration.urlString
        
        let request = SystemInfoRequest(
            url: baseUrl,
            method: .get
        )
        
        return request
    }
    
    /// Builds request to fetch default signer role id.
    /// - Returns: `SystemInfoRequest` model.
    public func buildRequestDefaultRoleIdRequest() -> DefaultRoleIdRequest {
        let baseUrl = self.apiConfiguration.urlString
        let path = self.keyValue/self.signerRoleDefault
        let url = baseUrl/path
        
        let request = DefaultRoleIdRequest(
            url: url,
            method: .get
        )
        
        return request
    }
}

import Foundation

/// Class provides functionality that allows to build requests
/// which are used to communicate with Key Server.
public class KeyServerApiRequestBuilder {
    
    public let apiConfiguration: ApiConfiguration
    
    public init(
        apiConfiguration: ApiConfiguration
        ) {
        self.apiConfiguration = apiConfiguration
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
            parametersEncoding: .urlEncoding
        )
        
        return request
    }
    
    /// Builds request to fetch wallet KDF params from api.
    /// - Parameters:
    ///     - walletInfo: Wallet info model.
    /// - Returns: `CreateWalletRequest` model.
    public func buildCreateWalletRequest(walletInfo: WalletInfoModel) throws -> CreateWalletRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets")
        
        let registrationInfoData = ApiDataRequest(data: walletInfo)
        let registrationInfoDataEncoded = try registrationInfoData.encode()
        
        let request = CreateWalletRequest(
            url: url,
            method: .post,
            parametersEncoding: .jsonEncoding,
            registrationInfoData: registrationInfoDataEncoded
        )
        
        return request
    }
    
    /// Builds request to update wallet. Used to update password.
    /// - Parameters:
    ///     - walletId: Wallet id.
    ///     - walletInfo: Wallet info model.
    ///     - requestSigner: Entity that signs request.
    ///     - sendDate: Request send date.
    /// - Returns: `UpdateWalletRequest` model.
    public func buildUpdateWalletRequest(
        walletId: String,
        walletInfo: WalletInfoModel,
        requestSigner: RequestSignerProtocol,
        sendDate: Date
        ) throws -> UpdateWalletRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets").addPath("\(walletId)")
        
        let walletInfoData = ApiDataRequest(data: walletInfo)
        let walletInfoDataEncoded = try walletInfoData.encode()
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = UpdateWalletRequest(
            url: url,
            method: .put,
            parametersEncoding: .jsonEncoding,
            registrationInfoData: walletInfoDataEncoded,
            signedHeaders: signedHeaders
        )
        
        return request
    }
    
    /// Builds request to verify wallet email.
    /// - Parameters:
    ///     - walletId: Wallet id.
    ///     - token: Verification token.
    /// - Returns: `VerifyEmailRequest` model.
    public func buildVerifyEmailRequest(walletId: String, token: String) throws -> VerifyEmailRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets/\(walletId)/verification")
        
        let attributes = EmailVerification.Attributes(token: token)
        let verification = EmailVerification(attributes: attributes)
        let verifyData = ApiDataRequest(data: verification)
        let verifyDataEncoded = try verifyData.encode()
        
        let request = VerifyEmailRequest(
            url: url,
            method: .put,
            verifyData: verifyDataEncoded
        )
        
        return request
    }
    
    /// Builds request to resend verification email.
    /// - Parameters:
    ///     - walletId: Wallet id.
    /// - Returns: `ResendEmailRequest` model.
    public func buildResendEmailRequest(walletId: String) -> ResendEmailRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets/\(walletId)/verification")
        
        let request = ResendEmailRequest(
            url: url,
            method: .post
        )
        
        return request
    }
    
    /// Builds request to fetch wallet KDF params.
    /// - Parameters:
    ///     - email: Email associated with wallet.
    ///     - isRecovery: Flag to indicate whether is recovery keychain data is requested.
    /// - Returns: `GetWalletKDFRequest` model.
    public func buildGetWalletKDFRequest(email: String, isRecovery: Bool) -> GetWalletKDFRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("wallets").addPath("kdf")
        
        var parameters = RequestParameters()
        parameters["email"] = email
        if isRecovery {
            parameters["is_recovery"] = "true"
        }
        
        let request = GetWalletKDFRequest(
            url: url,
            method: .get,
            parameters: parameters,
            parametersEncoding: .urlEncoding
        )
        
        return request
    }
    
    /// Builds request to fetch wallet data.
    /// - Parameters:
    ///     - walletId: Wallet id.
    /// - Returns: `GetWalletRequest` model.
    public func buildGetWalletRequest(walletId: String) -> GetWalletRequest {
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
}

import Foundation

public extension KeyServerApiRequestBuilder {

    private var verificationPath: String { "verification" }

    /// Builds request to verify wallet.
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - token: Verification token.
    /// - Returns: `VerifyWalletRequest` model.
    func buildVerifyWalletV2Request(
        walletId: String,
        token: String
        ) throws -> VerifyWalletRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/walletsPath/walletId/verificationPath

        let verification: WalletVerification = .init(
            attributes: .init(
                token: token
            )
        )
        let verifyData = ApiDataRequest<WalletVerification, WalletInfoModelV2.Include>(
            data: verification
        )
        let verifyDataEncoded = try verifyData.encode()

        let request = VerifyWalletRequest(
            url: url,
            method: .put,
            verifyData: verifyDataEncoded
        )

        return request
    }

    /// Builds request to resend verification code.
    /// - Parameters:
    ///   - walletId: Wallet id.
    /// - Returns: `ResendVerificationCodeRequest` model.
    func buildResendVerificationCodeRequest(
        walletId: String
        ) -> ResendVerificationCodeRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/walletsPath/walletId/verificationPath

        let request = ResendVerificationCodeRequest(
            url: url,
            method: .post
        )

        return request
    }
}

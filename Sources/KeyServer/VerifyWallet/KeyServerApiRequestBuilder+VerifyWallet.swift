import Foundation

public extension KeyServerApiRequestBuilder {

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

    /// Builds request to resend verification code.
    /// - Parameters:
    ///   - walletId: Wallet id.
    /// - Returns: `ResendVerificationCodeRequest` model.
    func buildResendVerificationCodeRequest(
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
}

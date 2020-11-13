import Foundation

public extension KeyServerApi {

    /// Method sends request to verify wallet.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.VerifyWalletResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - token: Verify token.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.VerifyWalletResult`
    func verifyWallet(
        walletId: String,
        token: String,
        completion: @escaping (_ result: Result<Void, Swift.Error>) -> Void
        ) {

        let request: VerifyWalletRequest
        do {
            request = try self.requestBuilder.buildVerifyWalletV2Request(
                walletId: walletId,
                token: token
            )
        } catch let error {
            completion(.failure(error))
            return
        }

        self.network.responseDataEmpty(
            url: request.url,
            method: request.method,
            bodyData: request.verifyData,
            completion: { (result) in

                switch result {

                case .failure(let errors):
                    completion(.failure(errors))

                case .success:
                    completion(.success(()))
                }
        })
    }

    /// Method sends request to resend verification code.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.ResendVerificationCodeResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.ResendVerificationCodeResult`
    func resendVerificationCode(
        walletId: String,
        completion: @escaping (_ result: Result<Void, Swift.Error>) -> Void
        ) {

        let request = self.requestBuilder.buildResendVerificationCodeRequest(
            walletId: walletId
        )

        self.network.responseDataEmpty(
            url: request.url,
            method: request.method,
            completion: { (result) in

                switch result {

                case .failure(let errors):
                    completion(.failure(errors))

                case .success:
                    completion(.success(()))
                }
        })
    }
}

import Foundation

public extension KeyServerApi {

    /// Result model for `completion` block of `KeyServerApi.verifyWallet(...)`
    enum VerifyWalletResult {

        /// Errors that may occur for `KeyServerApi.verifyWallet(...)`.
        public enum VerifyWalletError: Swift.Error, LocalizedError {

            /// Failed to build request model.
            case failedToGenerateRequest(Swift.Error)

            /// Verify wallet request failed. Contains `ApiErrors`.
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

        /// Case of failed verify wallet operation with `VerifyWalletResult.VerifyWalletError` model
        case failure(VerifyWalletError)
    }
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
        completion: @escaping (_ result: VerifyWalletResult) -> Void
        ) {

        let request: VerifyWalletRequest
        do {
            request = try self.requestBuilder.buildVerifyWalletV2Request(walletId: walletId, token: token)
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

    // MARK: Resend verification code

    /// Result model for `completion` block of `KeyServerApi.resendVerificationCode(...)`
    enum ResendVerificationCodeResult {

        /// Case of successful response from api
        case success

        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)
    }
    /// Method sends request to resend verification code.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.ResendVerificationCodeResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.ResendVerificationCodeResult`
    func resendVerificationCode(
        walletId: String,
        completion: @escaping (_ result: ResendVerificationCodeResult) -> Void
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
                    completion(.success)
                }
        })
    }
}

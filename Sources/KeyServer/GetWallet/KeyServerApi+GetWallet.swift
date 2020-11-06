import Foundation

public extension KeyServerApi {

    /// Result model for `completion` block of `KeyServerApi.requestWallet(...)`
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
                }
            }
        }

        /// Case of failed response from api with `RequestWalletResult.RequestWalletError` model
        case failure(RequestWalletError)

        /// Case of successful response from api with `WalletDataModel` model
        case success(walletData: WalletDataModel)
    }

    /// Method sends request to get wallet data from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestWalletResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - walletKDF: Wallet KDF params.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func requestWallet(
        walletId: String,
        walletKDF: WalletKDFParams,
        completion: @escaping (_ result: RequestWalletResult) -> Void
        ) -> Cancelable {

        let request = self.requestBuilder.buildGetWalletRequest(walletId: walletId)

        return self.requestWallet(
            walletId: walletId,
            walletKDF: walletKDF,
            request: request,
            initiateTFA: true,
            completion: completion
        )
    }

    /// Method sends request to get wallet data from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestWalletResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - walletKDF: Wallet KDF params.
    ///   - request: Wallet request model.
    ///   - initiateTFA: Flag to initiate TFA in case of TFA required error.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func requestWallet(
        walletId: String,
        walletKDF: WalletKDFParams,
        request: GetWalletRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: RequestWalletResult) -> Void
        ) -> Cancelable {

        var cancellable = self.network.getEmptyCancelable()
        cancellable = self.network.responseObject(
            ApiDataResponse<WalletDataResponse>.self,
            url: request.url,
            method: request.method,
            completion: { [weak self] result in
                switch result {

                case .success(let response):
                    let walletData = WalletDataModel.fromResponse(response.data, walletKDF: walletKDF)
                    completion(.success(walletData: walletData))

                case .failure(let errors):
                    cancellable.cancelable = self?.onRequestWalletFailed(
                        walletId: walletId,
                        walletKDF: walletKDF,
                        errors: errors,
                        request: request,
                        initiateTFA: initiateTFA,
                        completion: completion
                        )
                }
        })
        return cancellable
    }

    // MARK: - Private -

    @discardableResult
    private func onRequestWalletFailed(
        walletId: String,
        walletKDF: WalletKDFParams,
        errors: ApiErrors,
        request: GetWalletRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: RequestWalletResult) -> Void
        ) -> Cancelable {

        let cancellable = self.network.getEmptyCancelable()

        if errors.contains(status: ApiError.Status.forbidden, code: ApiError.Code.verificationRequired) {
            completion(.failure(.walletShouldBeVerified(walletId: walletId)))
        } else {
            errors.checkTFARequired(
                handler: self.tfaHandler,
                initiateTFA: initiateTFA,
                onCompletion: { [weak self] (tfaResult) in
                    switch tfaResult {

                    case .success:
                        cancellable.cancelable = self?.requestWallet(
                            walletId: walletId,
                            walletKDF: walletKDF,
                            request: request,
                            initiateTFA: false,
                            completion: completion
                            )

                    case .failure, .canceled:
                        completion(.failure(.tfaFailed))
                    }
                },
                onNoTFA: {
                    let requestError: RequestWalletResult.RequestWalletError
                    if errors.contains(status: ApiError.Status.notFound) {
                        requestError = .wrongPassword
                    } else {
                        requestError = .unknown(errors)
                    }

                    completion(.failure(requestError))
            })
        }

        return cancellable
    }
}

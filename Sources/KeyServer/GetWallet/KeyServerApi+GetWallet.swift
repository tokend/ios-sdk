import Foundation

public extension KeyServerApi {

    enum GetWalletError: Swift.Error, LocalizedError {

        case walletShouldBeVerified(walletId: String)
        case tfaFailed
        case tfaCancelled
        case wrongPassword

        // MARK: - Swift.Error

        public var errorDescription: String? {
            switch self {

            case .walletShouldBeVerified:
                return "Wallet should be verified"

            case .tfaFailed:
                return "TFA failed"
                
            case .tfaCancelled:
                return "TFA canceled"

            case .wrongPassword:
                return "Wrong password"
            }
        }
    }

    /// Method sends request to get wallet data from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestWalletResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func getWallet(
        walletId: String,
        completion: @escaping (_ result: Result<WalletDataResponse, Swift.Error>) -> Void
        ) -> Cancelable {

        let request = self.requestBuilder.buildGetWalletRequest(walletId: walletId)

        return self.performGetWalletRequest(
            request,
            walletId: walletId,
            initiateTFA: true,
            completion: completion
        )
    }
}

// MARK: - Private methods

private extension KeyServerApi {

    /// Method sends request to get wallet data from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestWalletResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - request: Wallet request model.
    ///   - initiateTFA: Flag to initiate TFA in case of TFA required error.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletResult`
    /// - Returns: `Cancelable`
    func performGetWalletRequest(
        _ request: GetWalletRequest,
        walletId: String,
        initiateTFA: Bool,
        completion: @escaping (_ result: Result<WalletDataResponse, Swift.Error>) -> Void
        ) -> Cancelable {

        var cancellable = self.network.getEmptyCancelable()

        cancellable = self.network.responseObject(
            ApiDataResponse<WalletDataResponse>.self,
            url: request.url,
            method: request.method,
            completion: { [weak self] result in
                switch result {

                case .success(let response):
                    completion(.success(response.data))

                case .failure(let errors):
                    cancellable.cancelable = self?.onGetWalletFailed(
                        walletId: walletId,
                        errors: errors,
                        request: request,
                        initiateTFA: initiateTFA,
                        completion: completion
                    )
                }
        })

        return cancellable
    }

    func onGetWalletFailed(
        walletId: String,
        errors: ApiErrors,
        request: GetWalletRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: Result<WalletDataResponse, Swift.Error>) -> Void
        ) -> Cancelable {

        let cancellable = self.network.getEmptyCancelable()

        if errors.contains(
            status: ApiError.Status.forbidden,
            code: ApiError.Code.verificationRequired
        ) {
            completion(.failure(GetWalletError.walletShouldBeVerified(walletId: walletId)))
        } else {
            errors.checkTFARequired(
                handler: tfaHandler,
                initiateTFA: initiateTFA,
                onCompletion: { [weak self] (tfaResult) in
                    switch tfaResult {

                    case .success:
                        cancellable.cancelable = self?.performGetWalletRequest(
                            request,
                            walletId: walletId,
                            initiateTFA: false,
                            completion: completion
                        )

                    case .failure:
                        completion(.failure(GetWalletError.tfaFailed))
                        
                    case .canceled:
                        completion(.failure(GetWalletError.tfaCancelled))
                    }
                },
                onNoTFA: {
                    let requestError: Swift.Error
                    if errors.contains(status: ApiError.Status.notFound) {
                        requestError = GetWalletError.wrongPassword
                    } else {
                        requestError = errors
                    }

                    completion(.failure(requestError))
            })
        }

        return cancellable
    }
}

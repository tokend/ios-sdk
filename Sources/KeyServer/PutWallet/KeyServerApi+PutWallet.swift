import Foundation

public extension KeyServerApi {

    enum UpdatePasswordV2Error: Swift.Error, LocalizedError {

        case tfaFailed
        case unverifiedWallet

        // MARK: - Swift.Error

        public var errorDescription: String? {
            switch self {

            case .tfaFailed:
                return "TFA failed"

            case .unverifiedWallet:
                return "Unverified wallet"
            }
        }
    }

    @available(*, deprecated, renamed: "putWallet")
    func performUpdatePasswordV2Request(
        login: String,
        walletId: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        walletInfo: WalletInfoModelV2,
        requestSigner: JSONAPI.RequestSignerProtocol,
        completion: @escaping (_ result: Result<WalletInfoResponse, Swift.Error>) -> Void
    ) -> Cancelable {

        putWallet(
            login: login,
            walletId: walletId,
            signingPassword: signingPassword,
            walletKDF: walletKDF,
            walletInfo: walletInfo,
            requestSigner: requestSigner,
            completion: completion
        )
    }

    func putWallet(
        login: String,
        walletId: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        walletInfo: WalletInfoModelV2,
        requestSigner: JSONAPI.RequestSignerProtocol,
        completion: @escaping (_ result: Result<WalletInfoResponse, Swift.Error>) -> Void
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildUpdateWalletV2Request(
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
                    login: login,
                    signingPassword: signingPassword,
                    walletKDF: walletKDF,
                    initiateTFA: true,
                    completion: completion
                )
            }
        )

        return cancelable
    }
}

// MARK: - Private

internal extension KeyServerApi {

    func performUpdatePasswordRequest(
        _ request: UpdateWalletRequest,
        login: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        initiateTFA: Bool,
        completion: @escaping (_ result: Result<WalletInfoResponse, Swift.Error>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        cancelable = self.network.responseDataObject(
            ApiDataResponse<WalletInfoResponse>.self,
            url: request.url,
            method: request.method,
            headers: request.signedHeaders,
            bodyData: request.registrationInfoData,
            completion: { [weak self] (result) in

                switch result {

                case .failure(let errors):
                    self?.handlePerformUpdatePasswordRequestFailure(
                        errors: errors,
                        cancelable: cancelable,
                        request,
                        login: login,
                        signingPassword: signingPassword,
                        walletKDF: walletKDF,
                        initiateTFA: initiateTFA,
                        completion: completion
                    )

                case .success(let object):
                    completion(.success(object.data))
                }
            }
        )

        return cancelable
    }

    func handlePerformUpdatePasswordRequestFailure(
        errors: ApiErrors,
        cancelable: Cancelable,
        _ request: UpdateWalletRequest,
        login: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        initiateTFA: Bool,
        completion: @escaping (_ result: Result<WalletInfoResponse, Swift.Error>) -> Void
    ) {

        if let error = errors.firstErrorWith(
            status: ApiError.Status.forbidden,
            code: ApiError.Code.tfaRequired
        ),
        let meta = error.tfaMeta {

            if initiateTFA {
                let onHandleTFAResult: (TFAResult) -> Void = { [weak self] tfaResult in
                    switch tfaResult {

                    case .success:
                        cancelable.cancelable = self?.performUpdatePasswordRequest(
                            request,
                            login: login,
                            signingPassword: signingPassword,
                            walletKDF: walletKDF,
                            initiateTFA: false,
                            completion: completion
                        )

                    case .failure, .canceled:
                        completion(.failure(UpdatePasswordV2Error.tfaFailed))
                    }
                }

                switch meta.factorTypeBase {

                case .codeBased:
                    tfaHandler.initiateTFA(
                        meta: meta,
                        completion: { tfaResult in
                            onHandleTFAResult(tfaResult)
                        })

                case .passwordBased(let metaModel):
                    TFAPasswordHandler(tfaHandler: tfaHandler).initiatePasswordTFA(
                        login: login,
                        password: signingPassword,
                        meta: metaModel,
                        kdfParams: walletKDF.kdfParams,
                        completion: { tfaResult in
                            onHandleTFAResult(tfaResult)
                        })
                }
            } else {
                completion(.failure(UpdatePasswordV2Error.tfaFailed))
            }
        } else {
            completion(.failure(errors))
        }
    }
}

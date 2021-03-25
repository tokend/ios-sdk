import Foundation

public extension KeyServerApi {

    enum PutWalletError: Swift.Error, LocalizedError {

        case tfaFailed
        case tfaCancelled
        case unverifiedWallet

        // MARK: - Swift.Error

        public var errorDescription: String? {
            switch self {

            case .tfaFailed:
                return "TFA failed"
                
            case .tfaCancelled:
                return "TFA cancelled"

            case .unverifiedWallet:
                return "Unverified wallet"
            }
        }
    }

    /// Used to change password
    @discardableResult
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

        self.requestBuilder.buildPutWalletRequest(
            walletId: walletId,
            walletInfo: walletInfo,
            requestSigner: requestSigner,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.performPutWalletRequest(
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

// MARK: - Internal methods

internal extension KeyServerApi {

    func performPutWalletRequest(
        _ request: PutWalletRequest,
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

                case .success(let object):
                    completion(.success(object.data))

                case .failure(let errors):
                    cancelable.cancelable = self?.onPutWalletFailed(
                        login: login,
                        signingPassword: signingPassword,
                        walletKDF: walletKDF,
                        errors: errors,
                        request: request,
                        initiateTFA: initiateTFA,
                        completion: completion
                    )
                }
            }
        )

        return cancelable
    }
}

// MARK: - Private methods

private extension KeyServerApi {

    func onPutWalletFailed(
        login: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        errors: ApiErrors,
        request: PutWalletRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: Result<WalletInfoResponse, Swift.Error>) -> Void
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        let putWalletTfaHandler: PutWalletTFAHandler = .init(
            defaultTFAHandler: tfaHandler,
            login: login,
            signingPassword: signingPassword,
            walletKDF: walletKDF
        )

        errors.checkTFARequired(
            handler: putWalletTfaHandler,
            initiateTFA: initiateTFA,
            onCompletion: { [weak self] (tfaResult) in
                switch tfaResult {

                case .success:
                    cancelable.cancelable = self?.performPutWalletRequest(
                        request,
                        login: login,
                        signingPassword: signingPassword,
                        walletKDF: walletKDF,
                        initiateTFA: false,
                        completion: completion
                    )

                case .failure:
                    completion(.failure(PutWalletError.tfaFailed))
                    
                case .canceled:
                    completion(.failure(PutWalletError.tfaCancelled))
                }
            },
            onNoTFA: {
                completion(.failure(errors))
            }
        )

        return cancelable
    }
}

// MARK: - PutWalletTFAHandler

private extension KeyServerApi {

    class PutWalletTFAHandler: TFAHandlerProtocol {

        private let defaultTFAHandler: TFAHandler
        private let login: String
        private let signingPassword: String
        private let walletKDF: WalletKDFParams

        init(
            defaultTFAHandler: TFAHandler,
            login: String,
            signingPassword: String,
            walletKDF: WalletKDFParams
        ) {

            self.defaultTFAHandler = defaultTFAHandler
            self.login = login
            self.signingPassword = signingPassword
            self.walletKDF = walletKDF
        }

        func initiateTFA(
            meta: TFAMetaResponse,
            completion: @escaping (TFAResult) -> Void
        ) {

            switch meta.factorTypeBase {

            case .codeBased:
                defaultTFAHandler.initiateTFA(
                    meta: meta,
                    completion: { (tfaResult) in

                        completion(tfaResult)
                    })

            case .passwordBased(let metaModel):
                TFAPasswordHandler(tfaHandler: defaultTFAHandler).initiatePasswordTFA(
                    login: login,
                    password: signingPassword,
                    meta: metaModel,
                    kdfParams: walletKDF.kdfParams,
                    completion: { tfaResult in
                        completion(tfaResult)
                    })
            }
        }
    }
}

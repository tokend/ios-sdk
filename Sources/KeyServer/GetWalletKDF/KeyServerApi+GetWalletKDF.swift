import Foundation

public extension KeyServerApi {

    /// Result model for `completion` block of `KeyServerApi.requestWalletKDF(...)`
    enum RequestWalletKDFResult {

        /// Errors that may occur for `KeyServerApi.requestWalletKDF(...)`
        public enum RequestError: Swift.Error, LocalizedError {

            /// KDF params not found for given login.
            @available(*, deprecated, renamed: "loginNotFound")
            case emailNotFound
            case loginNotFound

            /// Unrecognized error. Contains `ApiErrors`
            case unknown(ApiErrors)

            // MARK: - Swift.Error

            public var errorDescription: String? {
                switch self {
                case .emailNotFound,
                     .loginNotFound:
                    return "KDF for login not found"
                case .unknown(let errors):
                    return errors.localizedDescription
                }
            }
        }

        /// Case of successful response from api with `WalletKDFParams` model
        case success(walletKDF: WalletKDFParams)

        /// Case of failed response from api with `KeyServerApi.RequestWalletKDFResult.RequestError` model
        case failure(RequestError)
    }

    /// Method sends request to get wallet KDF params from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestWalletKDFResult`
    /// - Parameters:
    ///   - login: Login of associated wallet.
    ///   - isRecovery: Indicates whether is recovery wallet data should be fetched. Default is **false**.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletKDFResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func requestWalletKDF(
        login: String,
        isRecovery: Bool = false,
        completion: @escaping (_ result: RequestWalletKDFResult) -> Void
        ) -> Cancelable {

        let request = self.requestBuilder.buildGetWalletKDFRequest(login: login, isRecovery: isRecovery)

        return self.network.responseObject(
            ApiDataResponse<GetWalletKDFResponse>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { result in
                switch result {

                case .success(let walletKDFResponse):
                    guard let walletKDF = WalletKDFParams.fromResponse(walletKDFResponse.data) else {
                        completion(.failure(.loginNotFound))
                        return
                    }
                    completion(.success(walletKDF: walletKDF))

                case .failure(let errors):
                    let requestError: RequestWalletKDFResult.RequestError
                    if errors.contains(status: ApiError.Status.notFound) {
                        requestError = .loginNotFound
                    } else {
                        requestError = .unknown(errors)
                    }
                    completion(.failure(requestError))
                }
        })
    }
}

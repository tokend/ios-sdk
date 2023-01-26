import Foundation

public extension KeyServerApi {

    enum GetWalletKDFError: Swift.Error, LocalizedError {

        /// KDF params not found for given login.
        case loginNotFound
        case unauthorized

        // MARK: - Swift.Error

        public var errorDescription: String? {
            switch self {

            case .loginNotFound:
                return "KDF for login not found"
            case .unauthorized:
                return "Unauthorized"
            }
        }
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
    func getWalletKDF(
        login: String,
        isRecovery: Bool = false,
        completion: @escaping (_ result: Result<WalletKDFParams, Swift.Error>) -> Void
        ) -> Cancelable {

        let request = self.requestBuilder.buildGetWalletKDFRequest(
            login: login,
            isRecovery: isRecovery
        )

        return self.network.responseObject(
            ApiDataResponse<GetWalletKDFResponse>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in

                switch result {

                case .success(let walletKDFResponse):
                    guard let walletKDF = WalletKDFParams.fromResponse(walletKDFResponse.data) else {
                        completion(.failure(GetWalletKDFError.loginNotFound))
                        return
                    }
                    completion(.success(walletKDF))

                case .failure(let errors):
                    let requestError: Swift.Error
                    if errors.contains(status: ApiError.Status.notFound) {
                        requestError = GetWalletKDFError.loginNotFound
                    } else if errors.contains(status: ApiError.Status.unauthorized) {
                        requestError = GetWalletKDFError.unauthorized
                    }
                    else {
                        requestError = errors
                    }
                    completion(.failure(requestError))
                }
        })
    }
}

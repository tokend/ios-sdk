import Foundation

public extension KeyServerApi {

    /// Result model for `completion` block of `KeyServerApi.requestDefaultKDF(...)`
    enum RequestDefaultKDFResult {

        /// Errors that may occur for `KeyServerApi.requestDefaultKDF(...)`
        public enum RequestError: Swift.Error, LocalizedError {

            /// Unrecognized error. Contains `ApiErrors`
            case unknown(ApiErrors)

            // MARK: - Swift.Error

            public var errorDescription: String? {
                switch self {
                case .unknown(let errors):
                    return errors.localizedDescription
                }
            }
        }

        /// Case of successful response from api with `KDFParams` model
        case success(kdfParams: KDFParams)

        /// Case of failed response from api with `KeyServerApi.RequestDefaultKDFResult.RequestError` model
        case failure(RequestError)
    }

    /// Method sends request to get default KDF params from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestDefaultKDFResult`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestDefaultKDFResult`
    func requestDefaultKDF(
        completion: @escaping (_ result: RequestDefaultKDFResult) -> Void
        ) {

        let request = self.requestBuilder.buildGetKDFParamsRequest()

        self.network.responseObject(
            ApiDataResponse<GetKDFParamsResponse>.self,
            url: request.url,
            method: request.method,
            encoding: request.parametersEncoding,
            completion: { result in
                switch result {

                case .success(let kdfResponse):
                    let kdfParams = KDFParams.fromResponse(kdfResponse.data)
                    completion(.success(kdfParams: kdfParams))

                case .failure(let errors):
                    let requestError: RequestDefaultKDFResult.RequestError = .unknown(errors)
                    completion(.failure(requestError))
                }
        })
    }
}

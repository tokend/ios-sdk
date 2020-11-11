import Foundation

public extension KeyServerApi {

    /// Method sends request to get default KDF params from api.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestDefaultKDFResult`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestDefaultKDFResult`
    func getDefaultKDFParams(
        completion: @escaping (_ result: Result<KDFParams, Swift.Error>) -> Void
        ) {

        let request = self.requestBuilder.buildGetKDFParamsRequest()

        self.network.responseObject(
            ApiDataResponse<GetKDFParamsResponse>.self,
            url: request.url,
            method: request.method,
            encoding: request.parametersEncoding,
            completion: { (result) in

                switch result {

                case .success(let kdfResponse):
                    let kdfParams = KDFParams.fromResponse(kdfResponse.data)
                    completion(.success(kdfParams))

                case .failure(let errors):
                    completion(.failure(errors))
                }
        })
    }
}

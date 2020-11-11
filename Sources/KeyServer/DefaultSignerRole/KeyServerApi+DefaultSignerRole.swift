import Foundation

public extension KeyServerApi {

    /// Method sends request to get system info.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.DefaultSignerRoleIdResponse`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.DefaultSignerRoleIdResponse`
    func getDefaultSignerRoleId(
        completion: @escaping (_ result: Result<DefaultSignerRoleIdResponse, Swift.Error>) -> Void
        ) {

        let request = self.requestBuilder.buildDefaultSignerRoleIdRequest()

        self.network.responseObject(
            DefaultSignerRoleIdResponse.self,
            url: request.url,
            method: request.method,
            completion: { (result) in

                switch result {

                case .success(let object):
                    completion(.success(object))

                case .failure(let errors):
                    completion(.failure(errors))
                }
        })
    }
}

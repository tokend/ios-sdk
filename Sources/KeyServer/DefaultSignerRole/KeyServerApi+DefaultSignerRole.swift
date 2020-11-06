import Foundation

public extension KeyServerApi {

    /// Result model for `completion` block of `KeyServerApi.requestDefaultSignerRoleId(...)`
    enum RequestDefaultSignerRoleIdResult {

        /// Case of failed response from api with `ApiErrors` model
        case failure(ApiErrors)

        /// Case of successful response from api with `DefaultSignerRoleIdResponse` model
        case success(DefaultSignerRoleIdResponse)
    }
    /// Method sends request to get system info.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.DefaultSignerRoleIdResponse`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.DefaultSignerRoleIdResponse`
    func requestDefaultSignerRoleId(
        completion: @escaping (_ result: RequestDefaultSignerRoleIdResult) -> Void
        ) {

        let request = self.requestBuilder.buildDefaultRoleIdRequest()

        self.network.responseObject(
            DefaultSignerRoleIdResponse.self,
            url: request.url,
            method: request.method,
            completion: { (result) in
                switch result {

                case .failure(let errors):
                    completion(.failure(errors))

                case .success(let object):
                    completion(.success(object))
                }
        })
    }
}

import Foundation

public extension KeyServerApi {

    /// Method sends request to get system info.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RequestSystemInfoResult`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestSystemInfoResult`
    func requestSystemInfo(
        completion: @escaping (_ result: Result<SystemInfo, ApiErrors>) -> Void
        ) {

        let request = self.requestBuilder.buildRequestSystemInfoRequest()

        self.network.responseObject(
            SystemInfo.self,
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

import Foundation

public extension KeyServerApi {

    func performPostWalletV2Request(
        walletId: String,
        walletInfo: WalletInfoModelV2,
        completion: @escaping (_ result: Result<WalletInfoResponse, Swift.Error>) -> Void
    ) {

        let request: PostWalletRequest
        do {
            request = try self.requestBuilder.buildPostWalletV2Request(
                walletId: walletId,
                walletInfo: walletInfo
            )
        } catch let error {
            completion(.failure(error))
            return
        }

        self.network.responseDataObject(
            ApiDataResponse<WalletInfoResponse>.self,
            url: request.url,
            method: request.method,
            bodyData: request.registrationInfoData,
            completion: { (result) in

                switch result {

                case .failure(let errors):
                    completion(.failure(errors))

                case .success(let response):
                    completion(.success(response.data))
                }
        })
    }
}

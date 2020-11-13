import Foundation
import TokenDWallet
import DLCryptoKit

public extension KeyServerApi {

    enum CreateWalletV2Error: Swift.Error, LocalizedError {

        case loginAlreadyTaken

        // MARK: - Swift.Error

        public var errorDescription: String? {
            switch self {

            case .loginAlreadyTaken:
                return "Login already taken"
            }
        }
    }

    /// Method sends request to create wallet and register it within Key Server.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.CreateWalletRequestResult`
    /// - Parameters:
    ///   - walletInfo: Wallet info.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `CreateWalletRequestResult`
    func createWalletV2(
        walletInfo: WalletInfoModelV2,
        completion: @escaping (_ result: Result<WalletInfoResponse, Swift.Error>) -> Void
        ) {

        let request: CreateWalletRequest
        do {
            request = try self.requestBuilder.buildCreateWalletV2Request(
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
                    if errors.contains(status: ApiError.Status.conflict) {
                        completion(.failure(CreateWalletV2Error.loginAlreadyTaken))
                    } else {
                        completion(.failure(errors))
                    }

                case .success(let response):
                    completion(.success(response.data))
                }
        })
    }
}

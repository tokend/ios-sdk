import Foundation
import TokenDWallet
import DLCryptoKit

public extension KeyServerApi {
    
    // MARK: - Public -
    
    // MARK: Create Wallet
    
    /// Result model for `completion` block of `KeyServerApi.createWallet(...)`
    enum CreateWalletRequestResult {
        
        /// Errors that may occur for `KeyServerApi.createWallet(...)`.
        public enum CreateWalletError: Swift.Error, LocalizedError {
            
            /// General create wallet error. Contains `ApiErrors` model.
            case createFailed(ApiErrors)

            /// Occurs if wallet with given login already exists.
            @available(*, deprecated, renamed: "loginAlreadyTaken")
            case emailAlreadyTaken
            case loginAlreadyTaken

            /// Failed to build request model.
            case failedToGenerateRequest(Swift.Error)

            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .createFailed(let errors):
                    return errors.localizedDescription
                case .emailAlreadyTaken,
                     .loginAlreadyTaken:
                    return "Login already taken"
                case .failedToGenerateRequest(let error):
                    return error.localizedDescription
                }
            }
        }
        
        /// Case of failed create wallet operation with `CreateWalletRequestResult.CreateWalletError` model
        case failure(CreateWalletError)
        
        /// Case of successful response from api
        case success(WalletInfoResponse)
    }

    /// Method sends request to create wallet and register it within Key Server.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.CreateWalletRequestResult`
    /// - Parameters:
    ///   - walletInfo: Wallet info.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `CreateWalletRequestResult`
    func createWalletV2(
        walletInfo: WalletInfoModelV2,
        completion: @escaping (_ result: CreateWalletRequestResult) -> Void
        ) {

        let request: CreateWalletRequest
        do {
            request = try self.requestBuilder.buildCreateWalletV2Request(
                walletInfo: walletInfo
            )
        } catch let error {
            completion(.failure(.failedToGenerateRequest(error)))
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
                        completion(.failure(.loginAlreadyTaken))
                    } else {
                        completion(.failure(.createFailed(errors)))
                    }

                case .success(let response):
                    completion(.success(response.data))
                }
        })
    }
}

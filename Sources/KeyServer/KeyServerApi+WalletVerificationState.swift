import Foundation
import TokenDWallet
import DLCryptoKit

extension KeyServerApi {

    /// Result model for `completion` block of `KeyServerApi.getWalletVerificationState(...)`
    public enum GetWalletVerificationStateResult {

        /// Case of unverified wallet status
        case unverified

        /// Case of verified wallet status
        case verified
    }
    
    /// Method sends request to check wallet's verification status.
    /// The result of request will be fetched in `completion` block as
    /// `KeyServerApi.RequestWalletVerificationStateResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Result<GetWalletVerificationStateResult, Swift.Error>`
    public func getWalletVerificationState(
        walletId: String,
        completion: @escaping (_ result: Result<GetWalletVerificationStateResult, Swift.Error>) -> Void
        ) {
        
        let request = self.requestBuilder.buildGetWalletRequest(walletId: walletId)
        self.network.responseObject(
            ApiDataResponse<WalletDataResponse>.self,
            url: request.url,
            method: request.method,
            completion: { result in
                switch result {
                    
                case .success:
                    completion(.success(.verified))
                    
                case .failure(let errors):
                    if errors.contains(status: ApiError.Status.forbidden) {
                        completion(.success(.unverified))
                    } else {
                        completion(.failure(errors))
                    }
                }
        })
    }
}

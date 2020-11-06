import Foundation
import TokenDWallet
import DLCryptoKit

extension KeyServerApi {
    
    // MARK: - Public -
    
    /// Result model for `completion` block of `KeyServerApi.requestWalletVerificationState(...)`
    public enum RequestWalletVerificationStateResult {
        
        /// Case of unverified wallet status
        case unverified
        
        /// Case of verified wallet status
        case verified
        
        // Case of requets failure
        case failure(ApiErrors)
    }
    
    /// Method sends request to check wallet's verification status.
    /// The result of request will be fetched in `completion` block as
    /// `KeyServerApi.RequestWalletVerificationStateResult`
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RequestWalletVerificationStateResult`
    public func requestWalletVerificationState(
        walletId: String,
        completion: @escaping (_ result: RequestWalletVerificationStateResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildGetWalletRequest(walletId: walletId)
        self.network.responseObject(
            ApiDataResponse<WalletDataResponse>.self,
            url: request.url,
            method: request.method,
            completion: { result in
                switch result {
                    
                case .success:
                    completion(.verified)
                    
                case .failure(let errors):
                    if errors.contains(status: ApiError.Status.forbidden) {
                        completion(.unverified)
                    } else {
                        completion(.failure(errors))
                    }
                }
        })
    }
}

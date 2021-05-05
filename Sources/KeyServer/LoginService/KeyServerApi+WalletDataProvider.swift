import Foundation

extension KeyServerApi: KeyServerLoginService.WalletDataProvider {
    
    public func walletData(
        walletId: String,
        completion: @escaping (Result<WalletDataResponse, Error>) -> Void
    ) {
        
        getWallet(
            walletId: walletId,
            completion: completion
        )
    }
}

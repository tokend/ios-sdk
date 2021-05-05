import Foundation

extension KeyServerApi: KeyServerLoginService.WalletKDFProvider {
    
    public func walletKDF(
        login: String,
        isRecovery: Bool,
        completion: @escaping (Result<WalletKDFParams, Error>) -> Void
    ) {
        
        getWalletKDF(
            login: login,
            isRecovery: isRecovery,
            completion: completion
        )
    }
}

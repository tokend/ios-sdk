import Foundation

public protocol KeyServerLoginServiceWalletKDFProvider {
    
    func walletKDF(
        login: String,
        isRecovery: Bool,
        completion: @escaping (_ result: Swift.Result<WalletKDFParams, Swift.Error>) -> Void
    )
}

public extension KeyServerLoginService {
    
    typealias WalletKDFProvider = KeyServerLoginServiceWalletKDFProvider
}

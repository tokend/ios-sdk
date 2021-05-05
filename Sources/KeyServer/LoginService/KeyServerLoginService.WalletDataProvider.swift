import Foundation

public protocol KeyServerLoginServiceWalletDataProvider {
    
    func walletData(
        walletId: String,
        completion: @escaping (_ result: Result<WalletDataResponse, Swift.Error>) -> Void
    )
}

extension KeyServerLoginService {
    
    public typealias WalletDataProvider = KeyServerLoginServiceWalletDataProvider
}

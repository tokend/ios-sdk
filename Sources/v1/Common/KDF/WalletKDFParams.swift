import Foundation

public struct WalletKDFParams {
    
    public let kdfParams: KDFParams
    public let salt: Data
    
    // MARK: - Public
    
    public init(
        kdfParams: KDFParams,
        salt: Data
        ) {
        
        self.kdfParams = kdfParams
        self.salt = salt
    }
}

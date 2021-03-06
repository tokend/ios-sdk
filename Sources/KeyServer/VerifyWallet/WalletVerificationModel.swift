import Foundation

/// Wallet verification model. Needed for wallet verification request.
public struct WalletVerification: Encodable {
    
    public let attributes: Attributes
    
    public struct Attributes: Encodable {
        
        public let token: String
    }
}

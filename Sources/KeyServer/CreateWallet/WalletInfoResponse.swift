import Foundation

/// Wallet info response model.
public struct WalletInfoResponse: Decodable {
    
    public let type: String
    public let id: String
    public let attributes: Attributes
    
    public struct Attributes: Decodable {
        
        public let verified: Bool
    }
}

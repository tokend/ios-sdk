import Foundation

/// Transaction response model
public struct TransactionResponse: Decodable {
    
    // MARK: - Public properties
    
    public let ledger: UInt64
}

import Foundation

/// Transaction response model
@available(*, deprecated)
public struct TransactionResponse: Decodable {
    
    // MARK: - Public properties
    
    public let ledger: UInt64
}

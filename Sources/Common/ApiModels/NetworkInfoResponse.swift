import Foundation

/// Network info response model
public struct NetworkInfoResponse: Decodable {
    
    // MARK: - Public properties
    
    public let networkPassphrase: String
    public let adminAccountId: String
    public let masterExchangeName: String
    public let txExpirationPeriod: UInt64
    public let currentTime: Int64
    public let precision: Int64
}

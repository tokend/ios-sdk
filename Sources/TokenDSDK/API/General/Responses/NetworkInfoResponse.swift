import Foundation

public struct NetworkInfoResponse: Decodable {
    public let networkPassphrase: String
    public let masterAccountId: String
    public let masterExchangeName: String
    public let txExpirationPeriod: UInt64
    public let currentTime: Int64
}

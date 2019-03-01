import Foundation

public struct AuthResultResponse: Decodable {
    public let success: Bool
    public let walletId: String
}

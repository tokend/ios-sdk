import Foundation

public struct TFAVerifySignedTokenRequest {
    public let url: String
    public let method: RequestMethod
    public let signedTokenData: Data
}

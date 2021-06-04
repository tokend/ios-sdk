import Foundation

@available(*, deprecated)
public struct TFAVerifySignedTokenRequest {
    public let url: String
    public let method: RequestMethod
    public let signedTokenData: Data
}

import Foundation

public struct AccountRequest {
    public let url: String
    public let method: RequestMethod
    public let signedHeaders: RequestHeaders
}

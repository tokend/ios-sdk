import Foundation

public struct SignersRequest {
    public let url: String
    public let method: RequestMethod
    public let signedHeaders: RequestHeaders
}

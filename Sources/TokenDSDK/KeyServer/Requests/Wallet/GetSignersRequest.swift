import Foundation

public struct GetSignersRequest {
    public let url: String
    public let method: RequestMethod
    public let signedHeaders: RequestHeaders
}

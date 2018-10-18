import Foundation

public struct GetUserRequest {
    public let url: String
    public let method: RequestMethod
    public let signedHeaders: RequestHeaders
}

import Foundation

public struct VerifyEmailRequest {
    public let url: String
    public let method: RequestMethod
    public let verifyData: Data
}

import Foundation

public struct VerifyWalletRequest {
    public let url: String
    public let method: RequestMethod
    public let verifyData: Data
}

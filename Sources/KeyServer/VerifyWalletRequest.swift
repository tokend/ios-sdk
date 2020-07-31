import Foundation

@available(*, unavailable, renamed: "VerifyWalletRequest")
public typealias VerifyEmailRequest = VerifyWalletRequest

public struct VerifyWalletRequest {
    public let url: String
    public let method: RequestMethod
    public let verifyData: Data
}

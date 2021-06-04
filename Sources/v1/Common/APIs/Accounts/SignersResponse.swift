import Foundation

/// Container of signers
@available(*, deprecated, message: "Use AccountsApiV3")
public struct SignersResponse: Decodable {
    /// Array of `Account.Signer` models which are fetched from api
    public let signers: [SignerEntity]
}

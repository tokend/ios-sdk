import Foundation

/// Container of signers
public struct SignersResponse: Decodable {
    /// Array of `Account.Signer` models which are fetched from api
    public let signers: [SignerEntity]
}

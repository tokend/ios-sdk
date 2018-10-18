import Foundation

/// Container of signers
public struct Signers: Decodable {
    /// Array of `Account.Signer` models which are fetched from api
    public let signers: [Account.Signer]
}

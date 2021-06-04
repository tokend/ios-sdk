import Foundation

@available(*, deprecated, message: "Use AccountsApiV3")
open class SignerEntity: Decodable {
    
    // MARK: - Public properties
    
    /// AccountID
    public let publicKey: String
    public let weight: UInt32
    public let signerIdentity: UInt32
    public let signerTypeI: UInt32
    public let signerName: String
    
    // MARK: -
    
    public init(
        publicKey: String,
        weight: UInt32,
        signerIdentity: UInt32,
        signerTypeI: UInt32,
        signerName: String
        ) {
        
        self.publicKey = publicKey
        self.weight = weight
        self.signerIdentity = signerIdentity
        self.signerTypeI = signerTypeI
        self.signerName = signerName
    }
}

import Foundation
import DLCryptoKit
import TokenDWallet

public protocol RequestSignKeyDataProviderProtocol {
    func getPrivateKeyData() -> ECDSA.KeyData?
    func getPublicKeyString() -> String?
}

public class UnsafeRequestSignKeyDataProvider: RequestSignKeyDataProviderProtocol {
    
    private var keyPair: ECDSA.KeyData
    
    public init(keyPair: ECDSA.KeyData) {
        self.keyPair = keyPair
    }
    
    // MARK: - RequestSignKeyDataProviderProtocol
    
    /// Method returns value of `UnsafeRequestSignKeyDataProvider.keyPair`
    /// - Returns: `ECDSA.KeyData?`
    public func getPrivateKeyData() -> ECDSA.KeyData? {
        return self.keyPair
    }
    
    /// Method returns public key property of `UnsafeRequestSignKeyDataProvider.keyPair`
    /// - Returns: `String?`
    public func getPublicKeyString() -> String? {
        let publicKey = self.keyPair.getPublicKeyData()
        return Base32Check.encode(version: .accountIdEd25519, data: publicKey)
    }
}

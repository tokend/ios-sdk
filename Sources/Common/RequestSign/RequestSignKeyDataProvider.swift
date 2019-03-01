import Foundation
import DLCryptoKit
import TokenDWallet

public protocol RequestSignKeyDataProviderProtocol {
    
    func getPrivateKeyData(completion: @escaping (_ key: ECDSA.KeyData?) -> Void)
    func getPublicKeyString(completion: @escaping (_ key: String?) -> Void)
}

public class UnsafeRequestSignKeyDataProvider: RequestSignKeyDataProviderProtocol {
    
    // MARK: - Private properties
    
    private var keyPair: ECDSA.KeyData
    
    // MARK: -
    
    public init(keyPair: ECDSA.KeyData) {
        self.keyPair = keyPair
    }
    
    // MARK: - RequestSignKeyDataProviderProtocol
    
    /// Method returns value of `UnsafeRequestSignKeyDataProvider.keyPair`
    ///   - completion: Returns `ECDSA.KeyData` or nil.
    public func getPrivateKeyData(completion: @escaping (_ key: ECDSA.KeyData?) -> Void) {
        completion(self.keyPair)
    }
    
    /// Method returns public key property of `UnsafeRequestSignKeyDataProvider.keyPair`
    ///   - completion: Returns public key `String` or nil.
    public func getPublicKeyString(completion: @escaping (_ key: String?) -> Void) {
        let publicKeyData = self.keyPair.getPublicKeyData()
        let publicKey = Base32Check.encode(version: .accountIdEd25519, data: publicKeyData)
        completion(publicKey)
    }
}

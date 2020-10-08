import Foundation
import DLCryptoKit
import TokenDWallet

/// Allows to derive private key pair and wallet id from keychain data and wallet KDF params.
public enum KeyPairBuilder {

    /// Method derives private key pairs from keychain data and wallet KDF params.
    /// - Parameters:
    ///   - login: Login of associated wallet.
    ///   - password: Password to decypher private key.
    ///   - keychainData: Keychain data from Key Server.
    ///   - walletKDF: Wallet KDF params.
    /// - Returns: `ECDSA.KeyData` private keys.
    public static func getKeyPairs(
        forLogin login: String,
        password: String,
        keychainData: Data,
        walletKDF: WalletKDFParams
        ) throws -> [ECDSA.KeyData] {

        let key = try TokenDKDF.deriveKey(
            login: login,
            password: password,
            salt: walletKDF.salt,
            masterKey: TokenDKDF.deriveKeyMasterKeyWalletKey,
            n: walletKDF.kdfParams.n,
            r: walletKDF.kdfParams.r,
            p: walletKDF.kdfParams.p,
            keyLength: Int(walletKDF.kdfParams.bits / 8)
        )

        let keyPairs = try WalletDetailsModelV2.decryptKeyPairsFrom(
            keychainData: keychainData,
            keyData: key
        )

        return keyPairs
    }
    
    /// Method derives wallet id from wallet KDF params.
    /// - Parameters:
    ///   - login: Login of associated wallet.
    ///   - password: Password to wallet.
    ///   - walletKDF: Wallet KDF params.
    /// - Returns: Wallet id in raw data.
    public static func deriveWalletId(
        forLogin login: String,
        password: String,
        walletKDF: WalletKDFParams
        ) throws -> Data {
        
        let walletId = try TokenDKDF.deriveKey(
            login: login,
            password: password,
            salt: walletKDF.salt,
            masterKey: TokenDKDF.deriveKeyMasterKeyWalletId,
            n: walletKDF.kdfParams.n,
            r: walletKDF.kdfParams.r,
            p: walletKDF.kdfParams.p,
            keyLength: Int(walletKDF.kdfParams.bits / 8)
        )
        
        return walletId
    }
}

import Foundation
import DLCryptoKit
import TokenDWallet

/// Wallet details model that contains keychain data.
public struct WalletDetailsModel {
    
    public static let IVKey = "IV"
    public static let cipherTextKey = "cipherText"
    public static let cipherNameKey = "cipherName"
    public static let modeNameKey = "modeName"
    public static let seedKey = "seed"
    public static let seedsKey = "seeds"
    
    public static let supportedEncryptionAlgorithm = "aes"
    public static let supportedEncryptionMode = "gcm"
    
    public let walletIdHex: String
    public let accountIdBase32Check: String
    public let login: String
    public let saltBase64: String
    public let keychainDataBase64: String
    
    /// Errors that may occur for `WalletDetailsModel.createWalletDetails(...)`.
    public enum CreateWalletDetailsError: Swift.Error, LocalizedError {
        
        case failedToDeriveKey
        case failedToDeriveWalletId
        case failedToEncryptSeed
        
        // MARK: - Swift.Error
        
        public var errorDescription: String? {
            switch self {
            case .failedToDeriveKey:
                return "Failed to derive key"
            case .failedToDeriveWalletId:
                return "Failed to derive wallet id"
            case .failedToEncryptSeed:
                return "Failed to encrypt seed"
            }
        }
    }
    
    /// Method to create wallet details.
    /// - Parameters:
    ///   - login: Email associated with wallet.
    ///   - password: Password to wallet.
    ///   - keyPair: Private key pair.
    ///   - kdfParams: KDF params.
    ///   - salt: Encryption salt.
    ///   - IV: Encryption init vecto.
    /// - Returns: `WalletDetailsModel` model.
    public static func createWalletDetails(
        login: String,
        password: String,
        keyPair: ECDSA.KeyData,
        kdfParams: KDFParams,
        salt: Data, // 128 bits
        IV: Data // 96 bits
        ) throws -> WalletDetailsModel {
        
        let masterSeed = Base32Check.encode(version: .seedEd25519, data: keyPair.getSeedData())
        
        let publicKey = keyPair.getPublicKeyData()
        let accountId = Base32Check.encode(version: .accountIdEd25519, data: publicKey)
        
        let walletId: Data
        do {
            walletId = try TokenDKDF.deriveKey(
                login: login,
                password: password,
                salt: salt,
                masterKey: TokenDKDF.deriveKeyMasterKeyWalletId,
                n: kdfParams.n,
                r: kdfParams.r,
                p: kdfParams.p,
                keyLength: Int(kdfParams.bits / 8)
            )
        } catch {
            throw CreateWalletDetailsError.failedToDeriveWalletId
        }
        
        let derivedKey: Data
        do {
            derivedKey = try TokenDKDF.deriveKey(
                login: login,
                password: password,
                salt: salt,
                masterKey: TokenDKDF.deriveKeyMasterKeyWalletKey,
                n: kdfParams.n,
                r: kdfParams.r,
                p: kdfParams.p,
                keyLength: Int(kdfParams.bits / 8)
            )
        } catch {
            throw CreateWalletDetailsError.failedToDeriveKey
        }
        
        let keychainData = try self.makeKeychainData(
            masterSeedBase32Check: masterSeed,
            keyData: derivedKey,
            IV: IV
        )
        
        let walletInfo = WalletDetailsModel(
            walletIdHex: walletId.hexadecimal(),
            accountIdBase32Check: accountId,
            login: login,
            saltBase64: salt.base64EncodedString(),
            keychainDataBase64: keychainData.base64EncodedString()
        )
        
        return walletInfo
    }
    
    /// Errors that may occur for `WalletDetailsModel.decryptKeyPairFrom(...)`.
    public enum DecryptKeyPairError: Swift.Error, LocalizedError {
        
        case keySeedInitFailed(Swift.Error)
        case keychainDataMalformed
        case noSecretSeedFound
        case unableToDecodeEnvelope
        case unableToDecodeSeed(Swift.Error)
        case unableToDecodeSeedContainer
        case unableToDecryptCipherText
        case unsupportedEncryption(String)
        
        // MARK: - Swift.Error
        
        public var errorDescription: String? {
            switch self {
            case .keySeedInitFailed(let error):
                return error.localizedDescription
            case .keychainDataMalformed:
                return "Keychain data malformed"
            case .noSecretSeedFound:
                return "No secret seed found"
            case .unableToDecodeEnvelope:
                return "Unable to decode envelope"
            case .unableToDecodeSeed(let error):
                return error.localizedDescription
            case .unableToDecodeSeedContainer:
                return "Unable to decode seed container"
            case .unableToDecryptCipherText:
                return "Unable to decrypt cipher text"
            case .unsupportedEncryption(let encryption):
                return "Unsupported encryption: \(encryption)"
            }
        }
    }
    
    /// Method to decypher private key pair from given keychain data and cypher key.
    /// - Note: Current implementation assumes that private key data was encrypted
    /// using `AES256` algorithm in `GCM` mode.
    /// - Parameters:
    ///   - keychainData: Wallet keychain data fetched from Key server.
    ///   - keyData: Raw key data for symmetrical decryption.
    /// - Returns: `ECDSA.KeyData` private key.
    public static func decryptKeyPairFrom(keychainData: Data, keyData: Data) throws -> ECDSA.KeyData {
        guard let json = (try? JSONSerialization.jsonObject(with: keychainData, options: [])) as? JSON else {
            throw DecryptKeyPairError.unableToDecodeEnvelope
        }
        
        guard
            let ivBase64 = json[self.IVKey] as? String,
            let iv = ivBase64.dataFromBase64,
            let encryptedCipherTextBase64 = json[self.cipherTextKey] as? String,
            let encryptedCipherText = encryptedCipherTextBase64.dataFromBase64,
            let cipherName = json[self.cipherNameKey] as? String,
            let modeName = json[self.modeNameKey] as? String
            else {
                throw DecryptKeyPairError.keychainDataMalformed
        }
        
        guard
            cipherName == self.supportedEncryptionAlgorithm,
            modeName == self.supportedEncryptionMode
            else {
                throw DecryptKeyPairError.unsupportedEncryption("\(cipherName) \(modeName)")
        }
        
        let cipherTextData: Data
        do {
            cipherTextData = try AES256.aes256gcmDecrypt(
                cypherText: encryptedCipherText,
                key: keyData,
                iv: iv
            )
        } catch {
            throw DecryptKeyPairError.unableToDecryptCipherText
        }
        
        guard let seedJson = (try? JSONSerialization.jsonObject(with: cipherTextData, options: [])) as? JSON else {
            throw DecryptKeyPairError.unableToDecodeSeedContainer
        }

        let masterSeedBase32CheckOptional = seedJson[self.seedKey] ?? seedJson[self.seedsKey]

        let masterSeedBase32Check: String
        if let masterSeed = masterSeedBase32CheckOptional as? String {
            masterSeedBase32Check = masterSeed
        } else if let masterSeed = (masterSeedBase32CheckOptional as? [String])?.first {
            masterSeedBase32Check = masterSeed
        } else {
            throw DecryptKeyPairError.noSecretSeedFound
        }
        
        let masterSeed: Data
        do {
            masterSeed = try Base32Check.decodeCheck(
                expectedVersion: .seedEd25519,
                encoded: masterSeedBase32Check
            )
        } catch let error {
            throw DecryptKeyPairError.unableToDecodeSeed(error)
        }
        
        do {
            let keyPair = try ECDSA.KeyData(seed: masterSeed)
            return keyPair
        } catch let error {
            throw DecryptKeyPairError.keySeedInitFailed(error)
        }
    }
    
    // MARK: - Private
    
    private static func makeKeychainData(
        masterSeedBase32Check: String,
        keyData: Data,
        IV: Data
        ) throws -> Data {
        
        let ivBase64 = IV.base64EncodedString()
        
        let cipherText = "{\"\(self.seedKey)\":\"\(masterSeedBase32Check)\"}"
        let cipherTextData = Data(cipherText.utf8)
        
        let encryptedCipherText: Data
        do {
            encryptedCipherText = try AES256.aes256gcmEncrypt(
                message: cipherTextData,
                key: keyData,
                iv: IV
            )
        } catch {
            throw CreateWalletDetailsError.failedToEncryptSeed
        }
        let encryptedCipherTextBase64 = encryptedCipherText.base64EncodedString()
        
        var envelopeString = "{"
        envelopeString.append("\"\(self.modeNameKey)\":\"\(self.supportedEncryptionMode)\"")
        envelopeString.append(",")
        envelopeString.append("\"\(self.cipherNameKey)\":\"\(self.supportedEncryptionAlgorithm)\"")
        envelopeString.append(",")
        envelopeString.append("\"\(self.cipherTextKey)\":\"\(encryptedCipherTextBase64)\"")
        envelopeString.append(",")
        envelopeString.append("\"\(self.IVKey)\":\"\(ivBase64)\"")
        envelopeString.append("}")
        
        let envelopData = Data(envelopeString.utf8)
        
        return envelopData
    }
}

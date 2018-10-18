import Foundation
import TokenDWallet
import DLCryptoKit

/// Allows to build wallet info models as well as update account signers.
public struct WalletInfoBuilder {
    
    // MARK: - Public
    
    /// Keychain params model needed to build wallet info model.
    public struct KeychainParams {
        
        public let newKeyPair: ECDSA.KeyData
        public let newKeyPairKeychainSalt: Data
        public let newKeyPairKeychainIV: Data
        public let recoveryKeyPair: ECDSA.KeyData
        public let recoveryKeychainSalt: Data
        public let recoveryKeychainIV: Data
        public let passwordFactorKey: ECDSA.KeyData
        public let passwordFactorKeychainSalt: Data
        public let passwordFactorKeychainIV: Data
        
        public init(
            newKeyPair: ECDSA.KeyData,
            newKeyPairKeychainSalt: Data = Common.Random.generateRandom(length: 16),
            newKeyPairKeychainIV: Data = Common.Random.generateRandom(length: 12),
            recoveryKeyPair: ECDSA.KeyData,
            recoveryKeychainSalt: Data = Common.Random.generateRandom(length: 16),
            recoveryKeychainIV: Data = Common.Random.generateRandom(length: 12),
            passwordFactorKey: ECDSA.KeyData,
            passwordFactorKeychainSalt: Data = Common.Random.generateRandom(length: 16),
            passwordFactorKeychainIV: Data = Common.Random.generateRandom(length: 12)
            ) {
            
            self.newKeyPair = newKeyPair
            self.newKeyPairKeychainSalt = newKeyPairKeychainSalt
            self.newKeyPairKeychainIV = newKeyPairKeychainIV
            
            self.recoveryKeyPair = recoveryKeyPair
            self.recoveryKeychainSalt = recoveryKeychainSalt
            self.recoveryKeychainIV = recoveryKeychainIV
            
            self.passwordFactorKey = passwordFactorKey
            self.passwordFactorKeychainSalt = passwordFactorKeychainSalt
            self.passwordFactorKeychainIV = passwordFactorKeychainIV
        }
    }
    
    /// Result model for `WalletInfoBuilder.createWalletInfo(...)`.
    public enum CreateResult {
        
        /// Errors that may occur for `WalletInfoBuilder.createWalletInfo(...)`.
        public enum CreateError: Swift.Error, LocalizedError {
            
            case failedToCreatePasswordFactorDetails(Swift.Error)
            case failedToCreateRecoveryDetails(Swift.Error)
            case failedToCreateWalletDetails(Swift.Error)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .failedToCreatePasswordFactorDetails(let error):
                    return error.localizedDescription
                case .failedToCreateRecoveryDetails(let error):
                    return error.localizedDescription
                case .failedToCreateWalletDetails(let error):
                    return error.localizedDescription
                }
            }
        }
        
        /// Case of failed create wallet info operation with `CreateResult.CreateError` model.
        case failed(CreateError)
        
        /// Case of successful create wallet info operation with `WalletInfoModel` model.
        case succeeded(walletInfo: WalletInfoModel)
    }
    
    /// Method to create wallet info model.
    /// The result of this method will be used for wallet create and update methods.
    /// - Parameters:
    ///   - unchekedEmail: Email of associated wallet. Will be checked with `KDFParams.checkedEmail(...)`.
    ///   - password: Password to sign transaction envelope.
    ///   - kdfParams: KDF params.
    ///   - keychainParams: Key chain params model.
    ///   - transaction: Any transaction that should be send along with wallet info.
    ///   - referrerAccountId: Referrer account id.
    /// - Returns: `WalletInfoBuilder.CreateResult` model.
    public static func createWalletInfo(
        email unchekedEmail: String,
        password: String,
        kdfParams: KDFParams,
        keychainParams: KeychainParams,
        transaction: WalletInfoModel.Relationships.Transaction? = nil,
        referrerAccountId: String? = nil
        ) -> CreateResult {
        
        // wallet info
        let type = "wallet"
        let email = kdfParams.checkedEmail(unchekedEmail)
        
        let walletDetails: WalletDetailsModel
        do {
            walletDetails = try WalletDetailsModel.createWalletDetails(
                login: email,
                password: password,
                keyPair: keychainParams.newKeyPair,
                kdfParams: kdfParams,
                salt: keychainParams.newKeyPairKeychainSalt,
                IV: keychainParams.newKeyPairKeychainIV
            )
        } catch let error {
            return .failed(.failedToCreateWalletDetails(error))
        }
        
        // password factor info
        let passwordFactorDetails: WalletDetailsModel
        do {
            passwordFactorDetails = try WalletDetailsModel.createWalletDetails(
                login: email,
                password: password,
                keyPair: keychainParams.passwordFactorKey,
                kdfParams: kdfParams,
                salt: keychainParams.passwordFactorKeychainSalt,
                IV: keychainParams.passwordFactorKeychainIV
            )
        } catch let error {
            return .failed(.failedToCreatePasswordFactorDetails(error))
        }
        
        // recovery info
        let recoverySeedData = keychainParams.recoveryKeyPair.getSeedData()
        let recoverySeed = Base32Check.encode(version: .seedEd25519, data: recoverySeedData)
        let recoveryDetails: WalletDetailsModel
        do {
            recoveryDetails = try WalletDetailsModel.createWalletDetails(
                login: email,
                password: recoverySeed,
                keyPair: keychainParams.recoveryKeyPair,
                kdfParams: kdfParams,
                salt: keychainParams.recoveryKeychainSalt,
                IV: keychainParams.recoveryKeychainIV
            )
        } catch let error {
            return .failed(.failedToCreateRecoveryDetails(error))
        }
        
        // Registration Info
        
        // Relationships
        
        // KDF
        let kdfRelationship = WalletInfoModel.Relationships.KDF(
            type: kdfParams.type,
            id: kdfParams.id
        )
        
        // Password
        let passwordFactorAttributes = WalletInfoModel
            .Relationships
            .Factor
            .Attributes(
                accountId: passwordFactorDetails.accountIdBase32Check,
                keychainData: passwordFactorDetails.keychainDataBase64,
                salt: passwordFactorDetails.saltBase64
        )
        let passwordFactorRelationship = WalletInfoModel
            .Relationships
            .Factor(
                type: "password",
                id: nil,
                attributes: passwordFactorAttributes
        )
        
        // Recovery
        let recoveryFactorAttributes = WalletInfoModel
            .Relationships
            .Factor
            .Attributes(
                accountId: recoveryDetails.accountIdBase32Check,
                keychainData: recoveryDetails.keychainDataBase64,
                salt: recoveryDetails.saltBase64
        )
        let recoveryFactorRelationship = WalletInfoModel
            .Relationships
            .Factor(
                type: "recovery",
                id: recoveryDetails.walletIdHex,
                attributes: recoveryFactorAttributes
        )
        
        // Transaction
        var transactionAPIData: ApiDataRequest<WalletInfoModel.Relationships.Transaction>?
        if let transaction = transaction {
            transactionAPIData = ApiDataRequest(data: transaction)
        }
        var referrerAPIData: ApiDataRequest<WalletInfoModel.Relationships.Referrer>?
        if let refAccountId = referrerAccountId {
            referrerAPIData = ApiDataRequest(data:
                WalletInfoModel.Relationships.Referrer(
                    id: refAccountId,
                    type: .referrer
                )
            )
        }
        
        let relationships = WalletInfoModel.Relationships(
            referrer: referrerAPIData,
            transaction: transactionAPIData,
            kdf: ApiDataRequest(data: kdfRelationship),
            recovery: ApiDataRequest(data: recoveryFactorRelationship),
            factor: ApiDataRequest(data: passwordFactorRelationship)
        )
        
        // "data"
        let relationshipsAttributes = WalletInfoModel.Attributes(
            accountId: walletDetails.accountIdBase32Check,
            email: walletDetails.login,
            salt: walletDetails.saltBase64,
            keychainData: walletDetails.keychainDataBase64
        )
        
        let walletInfo = WalletInfoModel(
            type: type,
            id: walletDetails.walletIdHex,
            attributes: relationshipsAttributes,
            relationships: relationships
        )
        
        return .succeeded(walletInfo: walletInfo)
    }
    
    // MARK: Update Password
    
    /// Typealias for `TokenDWallet.SetOptionsOp`
    public typealias OperationTypealias = TokenDWallet.SetOptionsOp
    
    /// Result model for `WalletInfoBuilder.createUpdatePasswordWalletInfo(...)`.
    public enum CreateUpdatePasswordResult {
        
        /// Errors that may occur for `WalletInfoBuilder.createUpdatePasswordWalletInfo(...)`.
        public enum CreateError: Swift.Error, LocalizedError {
            
            case cannotCreateTransactionEnvelope
            case walletInfoBuilder(CreateResult.CreateError)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .cannotCreateTransactionEnvelope:
                    return "Cannot create transaction envelope"
                case .walletInfoBuilder(let error):
                    return error.localizedDescription
                }
            }
        }
        
        /// Case of failed create update wallet password operation
        /// with `CreateUpdatePasswordResult.CreateError` model.
        case failed(CreateError)
        
        /// Case of successful create update wallet password operation with `WalletInfoModel` model.
        case succeeded(walletInfo: WalletInfoModel)
    }
    
    /// Method to create update password wallet info model.
    /// The result of this method will be used for wallet password update method.
    /// - Parameters:
    ///   - email: Email associated with wallet.
    ///   - kdf: KDF params.
    ///   - signingKeyPair: Private key pair to sign transaction envelope.
    ///   - sourceAccountIdData: Source account id raw data.
    ///   - accountSigners: New account signers.
    ///   - originalAccountId: Original account id.
    ///   - networkInfo: `NetworkInfoModel` model.
    ///   - newPassword: New password.
    ///   - keychainParams: Keychain params.
    ///   - sendDate: Request send date.
    /// - Returns: `WalletInfoBuilder.CreateUpdatePasswordResult` model.
    static public func createUpdatePasswordWalletInfo(
        email: String,
        kdf: KDFParams,
        signingKeyPair: ECDSA.KeyData,
        sourceAccountIdData: Data,
        accountSigners: [Account.Signer],
        originalAccountId: String,
        networkInfo: NetworkInfoModel,
        newPassword: String,
        keychainParams: KeychainParams,
        sendDate: Date
        ) -> CreateUpdatePasswordResult {
        
        let checkedEmail = kdf.checkedEmail(email)
        
        var operations: [OperationTypealias] = []
        operations.append(self.addSigner(
            newKeyPair: keychainParams.newKeyPair,
            oldKeyPair: signingKeyPair,
            signers: accountSigners
            )
        )
        operations.append(contentsOf: self.replaceOldSigner(
            newKeyPair: keychainParams.newKeyPair,
            oldKeyPair: signingKeyPair,
            originalAccountId: originalAccountId,
            signers: accountSigners
        ))
        
        var signingAccountIdData = Uint256()
        signingAccountIdData.wrapped = sourceAccountIdData
        let signingAccountId = TokenDWallet.AccountID.keyTypeEd25519(signingAccountIdData)
        
        guard let envelopeBase64String = self.getTransactionEnvelopeBase64String(
            networkInfo: networkInfo,
            accountId: signingAccountId,
            operations: operations,
            keyPair: signingKeyPair,
            sendDate: sendDate
            ) else {
                return .failed(.cannotCreateTransactionEnvelope)
        }
        
        let attributes = WalletInfoModel.Relationships.Transaction.Attributes(envelope: envelopeBase64String)
        let transaction = WalletInfoModel.Relationships.Transaction(attributes: attributes)
        
        let createResult = WalletInfoBuilder.createWalletInfo(
            email: checkedEmail,
            password: newPassword,
            kdfParams: kdf,
            keychainParams: keychainParams,
            transaction: transaction
        )
        
        switch createResult {
            
        case .failed(let createError):
            return .failed(.walletInfoBuilder(createError))
            
        case .succeeded(let walletInfo):
            return .succeeded(walletInfo: walletInfo)
        }
    }
    
    /// Method to add new signer to account signers.
    /// - Parameters:
    ///   - newKeyPair: New key pair.
    ///   - oldKeyPair: Old key pair.
    ///   - signers: Account signers.
    /// - Returns: `WalletInfoBuilder.OperationTypealias` model.
    static public func addSigner(
        newKeyPair: ECDSA.KeyData,
        oldKeyPair: ECDSA.KeyData,
        signers: [Account.Signer]
        ) -> OperationTypealias {
        
        var accountIdData: Uint256 = Uint256()
        accountIdData.wrapped = newKeyPair.getPublicKeyData()
        let newKeyPairAccountId: TokenDWallet.AccountID = TokenDWallet.AccountID.keyTypeEd25519(accountIdData)
        let oldKeyPairAccountId = Base32Check.encode(version: .accountIdEd25519, data: oldKeyPair.getPublicKeyData())
        
        let name: String256 = "master"
        
        var signer = TokenDWallet.Signer(
            pubKey: newKeyPairAccountId,
            weight: 255,
            signerType: UInt32(Int32.max),
            identity: 1,
            name: name,
            ext: .emptyVersion()
        )
        
        for currSigner in signers where currSigner.publicKey == oldKeyPairAccountId {
            signer = TokenDWallet.Signer(
                pubKey: newKeyPairAccountId,
                weight: currSigner.weight,
                signerType: currSigner.signerTypeI,
                identity: currSigner.signerIdentity,
                name: currSigner.name,
                ext: .emptyVersion()
            )
        }
        
        return SetOptionsOp(
            masterWeight: nil,
            lowThreshold: nil,
            medThreshold: nil,
            highThreshold: nil,
            signer: signer,
            trustData: nil,
            limitsUpdateRequestData: nil,
            ext: SetOptionsOp.SetOptionsOpExt.emptyVersion()
        )
    }
    
    /// Method to replace old signer in account signers.
    /// - Parameters:
    ///   - newKeyPair: New key pair.
    ///   - oldKeyPair: Old key pair.
    ///   - originalAccountId: Original account id.
    ///   - signers: Account signers.
    /// - Returns: `WalletInfoBuilder.OperationTypealias` models.
    static public func replaceOldSigner(
        newKeyPair: ECDSA.KeyData,
        oldKeyPair: ECDSA.KeyData,
        originalAccountId: String,
        signers: [Account.Signer]
        ) -> [OperationTypealias] {
        
        let newKeyPairAccountId = Base32Check.encode(version: .accountIdEd25519, data: newKeyPair.getPublicKeyData())
        let oldKeyPairAccountId = Base32Check.encode(version: .accountIdEd25519, data: oldKeyPair.getPublicKeyData())
        
        var operations: [OperationTypealias] = []
        
        var signers = signers
        if let index = signers.index(where: { (signer) -> Bool in
            signer.publicKey == oldKeyPairAccountId
        }) {
            signers.append(signers.remove(at: index))
        }
        
        for signer in signers where signer.publicKey != newKeyPairAccountId {
            if signer.publicKey == originalAccountId {
                let masterWeight = Uint32(0)
                let operation = SetOptionsOp(
                    masterWeight: masterWeight,
                    lowThreshold: nil,
                    medThreshold: nil,
                    highThreshold: nil,
                    signer: nil,
                    trustData: nil,
                    limitsUpdateRequestData: nil,
                    ext: SetOptionsOp.SetOptionsOpExt.emptyVersion()
                )
                operations.append(operation)
                continue
            }
            
            guard let accountIdDecoded = try? Base32Check.decodeCheck(
                expectedVersion: .accountIdEd25519,
                encoded: signer.publicKey
                ) else {
                    continue
            }
            
            var accountIdData: Uint256 = Uint256()
            accountIdData.wrapped = accountIdDecoded
            let signerAccountId: TokenDWallet.AccountID = TokenDWallet.AccountID.keyTypeEd25519(accountIdData)
            
            let signer = TokenDWallet.Signer(
                pubKey: signerAccountId,
                weight: 0,
                signerType: 1,
                identity: signer.signerIdentity,
                name: signer.name,
                ext: .emptyVersion()
            )
            
            let setOptions = SetOptionsOp(
                masterWeight: nil,
                lowThreshold: nil,
                medThreshold: nil,
                highThreshold: nil,
                signer: signer,
                trustData: nil,
                limitsUpdateRequestData: nil,
                ext: SetOptionsOp.SetOptionsOpExt.emptyVersion()
            )
            
            operations.append(setOptions)
        }
        
        return operations
    }
    
    /// Method to create transaction envelope and encode it to `Base64`.
    /// - Parameters:
    ///   - networkInfo: `NetworkInfoModel` model.
    ///   - accountId: `AccountID` from `TokenDWallet`.
    ///   - operations: `WalletInfoBuilder.OperationTypealias` models.
    ///   - keyPair: Signing key pair.
    ///   - sendDate: Request send date.
    /// - Returns: Transaction envelope `Base64`-encoded string or `nil` if something fails.
    static public func getTransactionEnvelopeBase64String(
        networkInfo: NetworkInfoModel,
        accountId: TokenDWallet.AccountID,
        operations: [OperationTypealias],
        keyPair: ECDSA.KeyData,
        sendDate: Date
        ) -> String? {
        
        let builder = TransactionBuilder(
            networkParams: networkInfo.networkParams,
            sourceAccountId: accountId,
            params: networkInfo.getTxBuilderParams(sendDate: sendDate)
        )
        
        for operation in operations {
            builder.add(
                operationBody: .setOptions(operation),
                operationSourceAccount: nil
            )
        }
        
        guard let transaction = try? builder.buildTransaction() else {
            return nil
        }
        
        do {
            try transaction.addSignature(signer: keyPair)
            
            return transaction.getEnvelope().toXdrBase64String()
        } catch {
            return nil
        }
    }
}

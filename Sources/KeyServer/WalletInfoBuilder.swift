import Foundation
import TokenDWallet
import DLCryptoKit

/// Allows to build wallet info models as well as update account signers.
public struct WalletInfoBuilder {
    
    public typealias Referrer = WalletInfoModel.WalletInfoData.Relationships.Referrer
    public typealias Transaction = WalletInfoModel.WalletInfoData.Relationships.Transaction
    public typealias Factor = WalletInfoModel.WalletInfoData.Relationships.Factor
    
    // MARK: - Public
    
    /// Keychain params model needed to build wallet info model.
    public struct KeychainParams {
        
        public let newKeyPair: ECDSA.KeyData
        public let newKeyPairSalt: Data
        public let newKeyPairIV: Data
        public let recoveryKeyPair: ECDSA.KeyData
        public let recoveryKeyPairSalt: Data
        public let recoveryKeyPairIV: Data
        public let passwordFactorKeyPair: ECDSA.KeyData
        public let passwordFactorKeyPairSalt: Data
        public let passwordFactorKeyPairIV: Data
        
        public init(
            newKeyPair: ECDSA.KeyData,
            newKeyPairSalt: Data = Common.Random.generateRandom(length: 16),
            newKeyPairIV: Data = Common.Random.generateRandom(length: 12),
            recoveryKeyPair: ECDSA.KeyData,
            recoveryKeyPairSalt: Data = Common.Random.generateRandom(length: 16),
            recoveryKeyPairIV: Data = Common.Random.generateRandom(length: 12),
            passwordFactorKeyPair: ECDSA.KeyData,
            passwordFactorKeyPairSalt: Data = Common.Random.generateRandom(length: 16),
            passwordFactorKeyPairIV: Data = Common.Random.generateRandom(length: 12)
            ) {
            
            self.newKeyPair     = newKeyPair
            self.newKeyPairSalt = newKeyPairSalt
            self.newKeyPairIV   = newKeyPairIV
            
            self.recoveryKeyPair     = recoveryKeyPair
            self.recoveryKeyPairSalt = recoveryKeyPairSalt
            self.recoveryKeyPairIV   = recoveryKeyPairIV
            
            self.passwordFactorKeyPair     = passwordFactorKeyPair
            self.passwordFactorKeyPairSalt = passwordFactorKeyPairSalt
            self.passwordFactorKeyPairIV   = passwordFactorKeyPairIV
        }
    }
    
    /// Result model for `WalletInfoBuilder.createWalletInfo(...)`.
    public enum CreateResult {
        
        /// Errors that may occur for `WalletInfoBuilder.createWalletInfo(...)`.
        public enum CreateError: Swift.Error, LocalizedError {
            
            case failedToCreatePasswordFactorDetails(Swift.Error)
            case failedToCreateWalletDetails(Swift.Error)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .failedToCreatePasswordFactorDetails(let error):
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
    ///   - unchekedLogin: Login of associated wallet. Will be checked with `KDFParams.checkedLogin(...)`.
    ///   - password: Password to sign transaction envelope.
    ///   - kdfParams: KDF params.
    ///   - keychainParams: Key chain params model.
    ///   - transaction: Any transaction that should be send along with wallet info.
    ///   - referrerAccountId: Referrer account id.
    /// - Returns: `WalletInfoBuilder.CreateResult` model.
    public static func createWalletInfo(
        login unchekedLogin: String,
        password: String,
        kdfParams: KDFParams,
        keychainParams: KeychainParams,
        defaultSignerRole: UInt64,
        transaction: WalletInfoModel.WalletInfoData.Relationships.Transaction? = nil,
        referrerAccountId: String? = nil
        ) -> CreateResult {
        
        // wallet info
        let type = "wallet"
        let login = kdfParams.checkedLogin(unchekedLogin)
        
        let walletDetails: WalletDetailsModel
        do {
            walletDetails = try WalletDetailsModel.createWalletDetails(
                login: login,
                password: password,
                keyPair: keychainParams.newKeyPair,
                kdfParams: kdfParams,
                salt: keychainParams.newKeyPairSalt,
                IV: keychainParams.newKeyPairIV
            )
        } catch let error {
            return .failed(.failedToCreateWalletDetails(error))
        }
        
        // password factor info
        let passwordFactorDetails: WalletDetailsModel
        do {
            passwordFactorDetails = try WalletDetailsModel.createWalletDetails(
                login: login,
                password: password,
                keyPair: keychainParams.passwordFactorKeyPair,
                kdfParams: kdfParams,
                salt: keychainParams.passwordFactorKeyPairSalt,
                IV: keychainParams.passwordFactorKeyPairIV
            )
        } catch let error {
            return .failed(.failedToCreatePasswordFactorDetails(error))
        }
        
        // Registration Info
        
        // Relationships
        
        var included: [WalletInfoModel.Include] = []
        
        // KDF
        let kdfRelationship = WalletInfoModel.WalletInfoData.Relationships.KDF(
            id: kdfParams.id,
            type: kdfParams.type
        )
        
        included.append(kdfRelationship)
        
        // Password
        
        let passwordFactorRelationship = WalletInfoBuilder.getFactor(
            accountId: passwordFactorDetails.accountIdBase32Check,
            keychainData: passwordFactorDetails.keychainDataBase64,
            salt: passwordFactorDetails.saltBase64,
            id: passwordFactorDetails.walletIdHex,
            type: "password"
        )
        
        included.append(passwordFactorRelationship)

        // Signers
        let accountId = Base32Check.encode(
            version: .accountIdEd25519,
            data: keychainParams.newKeyPair.getPublicKeyData()
        )
        let signers = [
            WalletInfoModel.WalletInfoData.Relationships.Signer(
                id: accountId,
                type: "signer",
                attributes: WalletInfoModel.WalletInfoData.Relationships.Signer.Attributes(
                    roleId: defaultSignerRole,
                    weight: 1000,
                    identity: 0,
                    details: "{}"
                )
            )
        ]

        for signer in signers {
            included.append(signer)
        }

        // Transaction
        var transactionAPIData: ApiDataRequest<Transaction, WalletInfoModel.Include>?
        
        if let transaction = transaction {
            transactionAPIData = ApiDataRequest(data: transaction)
            included.append(transaction)
        }
        var referrerAPIData: ApiDataRequest<Referrer, WalletInfoModel.Include>?
        if let refAccountId = referrerAccountId {
            let referrerData = WalletInfoModel.WalletInfoData.Relationships.Referrer(
                id: refAccountId,
                type: "referrer"
            )
            referrerAPIData = ApiDataRequest(data: referrerData)
            included.append(referrerData)
        }
        
        let relationships = WalletInfoModel.WalletInfoData.Relationships(
            referrer: referrerAPIData,
            transaction: transactionAPIData,
            kdf: ApiDataRequest(data: kdfRelationship),
            signers: ApiDataRequest(data: signers),
            factor: ApiDataRequest(data: passwordFactorRelationship)
        )
        
        // "data"
        let relationshipsAttributes = WalletInfoModel.WalletInfoData.Attributes(
            accountId: walletDetails.accountIdBase32Check,
            email: walletDetails.login,
            salt: walletDetails.saltBase64,
            keychainData: walletDetails.keychainDataBase64
        )
        
        let walletInfoData = WalletInfoModel.WalletInfoData.init(
            type: type,
            id: walletDetails.walletIdHex,
            attributes: relationshipsAttributes,
            relationships: relationships
        )
        
        let walletInfo = WalletInfoModel(
            data: walletInfoData,
            included: included
        )
        
        return .succeeded(walletInfo: walletInfo)
    }
    
    private static func getFactor(
        accountId: String,
        keychainData: String,
        salt: String,
        id: String,
        type: String
        ) -> Factor {
        
        let attributes = Factor.Attributes(
            accountId: accountId,
            keychainData: keychainData,
            salt: salt
        )
        
        return Factor(
            id: id,
            type: type,
            attributes: attributes
        )
    }
    
    // MARK: Update Password
    
    /// Typealias for `TokenDWallet.SetOptionsOp`
    public typealias OperationTypealias = TokenDWallet.ManageSignerOp
    
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
    ///   - login: Login associated with wallet.
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
        login: String,
        kdf: KDFParams,
        signingKeyPair: ECDSA.KeyData,
        sourceAccountIdData: Data,
        accountSigners: [Horizon.SignerResource],
        defaultRoleId: UInt64,
        originalAccountId: String,
        networkInfo: NetworkInfoModel,
        newPassword: String,
        keychainParams: KeychainParams,
        sendDate: Date
    ) -> CreateUpdatePasswordResult {
        
        let checkedLogin = kdf.checkedLogin(login)
        
        var operations: [OperationTypealias] = []
        operations.append(contentsOf: self.addSigner(
            newKeyPair: keychainParams.newKeyPair,
            oldKeyPair: signingKeyPair,
            signers: accountSigners,
            defaultRoleId: defaultRoleId
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
        
        let attributes = WalletInfoModel.WalletInfoData.Relationships.Transaction.Attributes(
            envelope: envelopeBase64String
        )
        let transaction = WalletInfoModel.WalletInfoData.Relationships.Transaction(
            id: "uniqueTransaction",
            type: "transaction",
            attributes: attributes
        )
        
        let createResult = WalletInfoBuilder.createWalletInfo(
            login: checkedLogin,
            password: newPassword,
            kdfParams: kdf,
            keychainParams: keychainParams,
            // TODO: - Set valid default signer
            defaultSignerRole: 1,
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
        signers: [Horizon.SignerResource],
        defaultRoleId: UInt64
        ) -> [OperationTypealias] {
        
        var accountIdData: Uint256 = Uint256()
        accountIdData.wrapped = newKeyPair.getPublicKeyData()
        let newKeyPairAccountId: TokenDWallet.AccountID = TokenDWallet.AccountID.keyTypeEd25519(accountIdData)
        let oldKeyPairAccountId = Base32Check.encode(version: .accountIdEd25519, data: oldKeyPair.getPublicKeyData())
        
        var operations: [OperationTypealias] = []
        
        for currSigner in signers where currSigner.id == oldKeyPairAccountId {
            guard let role = currSigner.role,
                let roleStringId = role.id,
                let roleID = Uint64(roleStringId),
                roleID != 1 else {
                    continue
            }
            
            var details = "{}"
            
            if let detailsData = try? JSONSerialization.data(
                withJSONObject: currSigner.details,
                options: .prettyPrinted
                ),
                let encodedDetails = String(data: detailsData, encoding: .utf8) {
                
                details = encodedDetails
            }
            
            let updateSignerData = UpdateSignerData(
                publicKey: newKeyPairAccountId,
                roleID: roleID,
                weight: currSigner.weight,
                identity: currSigner.identity,
                details: details,
                ext: .emptyVersion()
            )
            
            let operation = ManageSignerOp(
                data: ManageSignerOp.ManageSignerOpData.create(updateSignerData),
                ext: .emptyVersion()
            )
            operations.append(operation)
        }
        
        if operations.isEmpty {
            let updateSignerData = UpdateSignerData(
                publicKey: newKeyPairAccountId,
                roleID: defaultRoleId,
                weight: 1000,
                identity: 0,
                details: "{}",
                ext: .emptyVersion()
            )
            
            let operation = ManageSignerOp(
                data: ManageSignerOp.ManageSignerOpData.create(updateSignerData),
                ext: .emptyVersion()
            )
            operations.append(operation)
        }
        
        return operations
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
        signers: [Horizon.SignerResource]
        ) -> [OperationTypealias] {
        
        let newKeyPairAccountId = Base32Check.encode(version: .accountIdEd25519, data: newKeyPair.getPublicKeyData())
        let oldKeyPairAccountId = Base32Check.encode(version: .accountIdEd25519, data: oldKeyPair.getPublicKeyData())
        
        var operations: [OperationTypealias] = []
        
        var signers = signers
        if let index = signers.index(where: { (signer) -> Bool in
            signer.id == oldKeyPairAccountId
        }) {
            signers.append(signers.remove(at: index))
        }
        
        for signer in signers where signer.id != newKeyPairAccountId {
            
            guard let signerId = signer.id,
                let accountIdDecoded = try? Base32Check.decodeCheck(
                    expectedVersion: .accountIdEd25519,
                    encoded: signerId
                ) else {
                    continue
            }
            
            var accountIdData: Uint256 = Uint256()
            accountIdData.wrapped = accountIdDecoded
            let signerAccountId: TokenDWallet.AccountID = TokenDWallet.AccountID.keyTypeEd25519(accountIdData)
            
            guard let role = signer.role,
                let roleStringId = role.id,
                roleStringId != "1" else {
                    continue
            }
            
            let removingSignerData = RemoveSignerData(
                publicKey: signerAccountId,
                ext: .emptyVersion()
            )
            
            let removeSignerOp = ManageSignerOp(
                data: .remove(removingSignerData),
                ext: .emptyVersion()
            )
            operations.append(removeSignerOp)
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
                operationBody: .manageSigner(operation),
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

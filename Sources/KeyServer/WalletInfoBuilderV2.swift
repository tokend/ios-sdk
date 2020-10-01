import Foundation
import TokenDWallet
import DLCryptoKit

/// Allows to build wallet info models as well as update account signers.
public struct WalletInfoBuilderV2 {

    public typealias Referrer = WalletInfoModel.WalletInfoData.Relationships.Referrer
    public typealias Transaction = WalletInfoModel.WalletInfoData.Relationships.Transaction
    public typealias Factor = WalletInfoModel.WalletInfoData.Relationships.Factor

    // MARK: - Public

    /// Errors that may occur for `WalletInfoBuilderV2.createWalletInfo(...)`.
    public enum CreateWalletInfoError: Swift.Error, LocalizedError {

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
        keys: [ECDSA.KeyData],
        signers: [WalletInfoModel.WalletInfoData.Relationships.Signer],
        defaultSignerRole: UInt64,
        transaction: WalletInfoModel.WalletInfoData.Relationships.Transaction? = nil,
        referrerAccountId: String? = nil
    ) -> Result<WalletInfoModel, Swift.Error> {

        // wallet info
        let type = "wallet"
        let login = kdfParams.checkedLogin(unchekedLogin)

        let walletDetails: WalletDetailsModelV2
        let newKeyPairSalt: Data = Common.Random.generateRandom(length: 16)
        let newKeyPairIV: Data = Common.Random.generateRandom(length: 12)
        do {
            walletDetails = try WalletDetailsModelV2.createWalletDetails(
                login: login,
                password: password,
                keyPairs: keys,
                kdfParams: kdfParams,
                salt: newKeyPairSalt,
                IV: newKeyPairIV
            )
        } catch let error {
            return .failure(CreateWalletInfoError.failedToCreateWalletDetails(error))
        }

        // password factor info
        let passwordFactorKeyPair: ECDSA.KeyData
        do {
            passwordFactorKeyPair = try .init()
        } catch {
            return .failure(error)
        }
        let passwordFactorKeyPairSalt: Data = Common.Random.generateRandom(length: 16)
        let passwordFactorKeyPairIV: Data = Common.Random.generateRandom(length: 12)
        let passwordFactorDetails: WalletDetailsModelV2
        do {
            passwordFactorDetails = try WalletDetailsModelV2.createWalletDetails(
                login: login,
                password: password,
                keyPairs: [passwordFactorKeyPair],
                kdfParams: kdfParams,
                salt: passwordFactorKeyPairSalt,
                IV: passwordFactorKeyPairIV
            )
        } catch let error {
            return .failure(CreateWalletInfoError.failedToCreatePasswordFactorDetails(error))
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

        let passwordFactorRelationship = WalletInfoBuilderV2.getFactor(
            accountId: passwordFactorDetails.accountIdBase32Check,
            keychainData: passwordFactorDetails.keychainDataBase64,
            salt: passwordFactorDetails.saltBase64,
            id: passwordFactorDetails.walletIdHex,
            type: "password"
        )

        included.append(passwordFactorRelationship)

        // Signers
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

        return .success(walletInfo)
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

    /// Errors that may occur for `WalletInfoBuilderV2.createChangePasswordWalletInfo(...)`.
    public enum CreateChangePasswordWalletInfoError: Swift.Error, LocalizedError {

        case cannotCreateTransactionEnvelope
        case walletInfoBuilder(Swift.Error)

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

    /// Method to create change password wallet info model.
    /// The result of this method will be used for wallet password change method.
    /// - Parameters:
    ///   - login: Login associated with wallet.
    ///   - kdf: KDF params.
    ///   - newPassword: New password.
    ///   - keychainParams: Keychain params.
    ///   - signedTransaction: Signer transaction with manage signers operations.
    /// - Returns: `WalletInfoBuilder.CreateUpdatePasswordResult` model.
    static public func createChangePasswordWalletInfo(
        login: String,
        newPassword: String,
        kdf: KDFParams,
        keys: [ECDSA.KeyData],
        signers: [WalletInfoModel.WalletInfoData.Relationships.Signer],
        defaultSignerRole: UInt64,
        signedTransaction: TransactionModel
    ) -> Result<WalletInfoModel, Swift.Error> {

        let checkedLogin = kdf.checkedLogin(login)

        let envelopeBase64String = signedTransaction.getEnvelope().toXdrBase64String()

        let attributes = WalletInfoModel.WalletInfoData.Relationships.Transaction.Attributes(
            envelope: envelopeBase64String
        )
        let transaction = WalletInfoModel.WalletInfoData.Relationships.Transaction(
            id: "uniqueTransaction",
            type: "transaction",
            attributes: attributes
        )

        let createResult = WalletInfoBuilderV2.createWalletInfo(
            login: checkedLogin,
            password: newPassword,
            kdfParams: kdf,
            keys: keys,
            signers: signers,
            defaultSignerRole: defaultSignerRole,
            transaction: transaction
        )

        switch createResult {

        case .failure(let error):
            return .failure(CreateChangePasswordWalletInfoError.walletInfoBuilder(error))

        case .success(let walletInfo):
            return .success(walletInfo)
        }
    }
}

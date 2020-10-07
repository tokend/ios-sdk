import Foundation

/// Wallet info model. Used wallet creation and update operations.
public struct RecoveryWalletInfoModelV2: Encodable {

    public let data: WalletInfoData
    public let included: [WalletInfoModelV2.Include]

    public struct WalletInfoData: Encodable {
        public let type: String
        public let id: String

        public let attributes: Attributes
        public let relationships: Relationships

        public struct Attributes: Encodable {

            public let accountId: String
            public let email: String?
            public let salt: String
            public let keychainData: String
        }

        public struct Relationships: Encodable {

            public typealias Relationships = WalletInfoModelV2.WalletInfoData.Relationships
            public typealias Include = WalletInfoModelV2.Include

            public let transaction: ApiDataRequest<Relationships.Transaction, Include>?
            public let kdf: ApiDataRequest<Relationships.KDF, Include>
            public let signer: ApiDataRequest<Relationships.Signer, Include>
            public let factor: ApiDataRequest<Relationships.Factor, Include>
        }
    }
}

extension RecoveryWalletInfoModelV2: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("type: \(self.data.type)")
        fields.append("id: \(self.data.id)")
        fields.append("attributes: \(self.data.attributes.debugDescription)")
        fields.append("relationships: \(self.data.relationships.debugDescription)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension RecoveryWalletInfoModelV2.WalletInfoData.Attributes: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("accountId: \(self.accountId)")
        if let email = self.email {
            fields.append("email: \(email)")
        }
        fields.append(DebugFormatted(base64EncodedData: self.salt, title: "salt", clipOriginal: false))
        fields.append(DebugFormatted(base64EncodedString: self.keychainData, title: "keychainData", clipOriginal: true))

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension RecoveryWalletInfoModelV2.WalletInfoData.Relationships: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []
        if let transaction = self.transaction {
            fields.append("transaction: \(transaction.data.debugDescription)")
        }
        fields.append("kdf: \(self.kdf.data.debugDescription)")
        fields.append("signers: \(self.signer.data.debugDescription)")
        fields.append("factor: \(self.factor.data.debugDescription)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

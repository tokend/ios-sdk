import Foundation

/// Wallet info model. Used wallet creation and update operations.
public struct WalletInfoModelV2: Encodable {

    public var data: WalletInfoData
    public let included: [Include]

    public struct WalletInfoData: Encodable {
        public let type: String
        public let id: String

        public let attributes: Attributes
        public var relationships: Relationships

        public struct Attributes: Encodable {

            public let accountId: String
            public let login: String?
            public let salt: String
            public let keychainData: String

            public enum CodingKeys: String, CodingKey {
                case accountId
                // Backend legacy
                case login = "email"
                case salt
                case keychainData
            }
        }

        public struct Relationships: Encodable {

            public var mutableJSON: [CodingKeys: Encodable]

            public enum CodingKeys: RawRepresentable, Hashable {
                public typealias RawValue = String

                case transaction
                case kdf
                case signers
                case signer
                case factor
                case custom(key: RawValue)

                public init?(rawValue: String) {
                    if Self.factor.rawValue == rawValue { self = .factor }
                    if Self.kdf.rawValue == rawValue { self = .kdf }
                    if Self.signer.rawValue == rawValue { self = .signer }
                    if Self.signers.rawValue == rawValue { self = .signers }
                    if Self.transaction.rawValue == rawValue { self = .signers }
                    self = .custom(key: rawValue)
                }

                public var rawValue: RawValue {

                    switch self {
                    case .factor: return "factor"
                    case .kdf: return "kdf"
                    case .signer: return "signer"
                    case .signers: return "signers"
                    case .transaction: return "transaction"
                    case .custom(let key): return key
                    }
                }
            }

            init(
                transaction: ApiDataRequest<Transaction, Include>?,
                kdf: ApiDataRequest<KDF, Include>,
                signers: ApiDataRequest<[Signer], Include>?,
                signer: ApiDataRequest<Signer, Include>?,
                factor: ApiDataRequest<Factor, Include>
            ) {

                self.mutableJSON = [
                    .transaction: transaction,
                    .kdf: kdf,
                    .signers: signers,
                    .signer: signer,
                    .factor: factor
                ]
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                struct AnyEncodable: Encodable {

                    let value: Encodable
                    init(value: Encodable) {
                        self.value = value
                    }

                    func encode(to encoder: Encoder) throws {
                        try value.encode(to: encoder)
                    }
                }

                let anyMutableJSON = mutableJSON
                    .reduce(into: [CodingKeys.RawValue: Encodable]()) { (result, tuple) in
                        result[tuple.key.rawValue] = tuple.value
                    }
                    .mapValues({ AnyEncodable(value: $0) })
                try container.encode(anyMutableJSON)
            }

            public class Transaction: Include {

                public let attributes: Attributes

                public init(id: String, type: String, attributes: Attributes) {
                    self.attributes = attributes

                    super.init(id: id, type: type)
                }

                public struct Attributes: Encodable {

                    public let envelope: String
                }

                public enum TransactionIncludeKeys: CodingKey {
                    case attributes
                }

                override public func encode(to encoder: Encoder) throws {
                    try super.encode(to: encoder)
                    var container = encoder.container(keyedBy: TransactionIncludeKeys.self)

                    try? container.encode(self.attributes, forKey: .attributes)
                }
            }

            public class KDF: Include {

                public override init(id: String, type: String) {
                    super.init(id: id, type: type)
                }
            }

            public class Signer: Include {

                public static let defaultType: String = "signer"
                public static let defaultWeight: UInt64 = 1000
                public static let defaultIdentity: UInt64 = 0
                public static let defaultDetails: String = "{}"

                public init(id: String, type: String, attributes: Attributes) {
                    self.attributes = attributes

                    super.init(id: id, type: type)
                }

                public let attributes: Attributes

                public struct Attributes: Encodable {

                    public init(roleId: UInt64, weight: UInt64, identity: UInt64, details: String) {
                        self.roleId = roleId
                        self.weight = weight
                        self.identity = identity
                        self.details = details
                    }

                    public let roleId: UInt64
                    public let weight: UInt64
                    public let identity: UInt64
                    public let details: String

                    public enum AttributesIncludeKeys: CodingKey {
                        case roleId
                        case weight
                        case identity
                        case details
                    }

                    public func encode(to encoder: Encoder) throws {
                        var container = encoder.container(keyedBy: AttributesIncludeKeys.self)

                        try? container.encode(self.roleId, forKey: .roleId)
                        try? container.encode(self.weight, forKey: .weight)
                        try? container.encode(self.identity, forKey: .identity)
                        try? container.encode(self.details, forKey: .details)
                    }
                }

                public enum SignerIncludeKeys: CodingKey {
                    case attributes
                }

                override public func encode(to encoder: Encoder) throws {
                    try super.encode(to: encoder)
                    var container = encoder.container(keyedBy: SignerIncludeKeys.self)

                    try? container.encode(self.attributes, forKey: .attributes)
                }

                public class func defaultSigner(
                    with id: String,
                    roleId: UInt64
                ) -> Signer {

                    .init(
                        id: id,
                        type: Signer.defaultType,
                        attributes: .init(
                            roleId: roleId,
                            weight: Signer.defaultWeight,
                            identity: Signer.defaultIdentity,
                            details: Signer.defaultDetails
                        )
                    )
                }
            }

            public class Factor: Include {

                public init(id: String, type: String, attributes: Attributes) {
                    self.attributes = attributes

                    super.init(id: id, type: type)
                }

                public let attributes: Attributes

                public struct Attributes: Encodable {

                    public let accountId: String
                    public let keychainData: String
                    public let salt: String
                }

                public enum FactorIncludeKeys: CodingKey {
                    case attributes
                }

                override public func encode(to encoder: Encoder) throws {
                    try super.encode(to: encoder)
                    var container = encoder.container(keyedBy: FactorIncludeKeys.self)

                    try? container.encode(self.attributes, forKey: .attributes)
                }
            }
        }
    }

    public class Include: Encodable {
        public let id: String
        public let type: String

        public init(id: String, type: String) {
            self.id = id
            self.type = type
        }

        public enum CodingKeys: CodingKey {
            case id
            case type
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try? container.encode(self.id, forKey: .id)
            try? container.encode(self.type, forKey: .type)
        }
    }
}

extension WalletInfoModelV2: CustomDebugStringConvertible {

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

extension WalletInfoModelV2.WalletInfoData.Attributes: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("accountId: \(self.accountId)")
        if let email = self.login {
            fields.append("email: \(email)")
        }
        fields.append(DebugFormatted(base64EncodedData: self.salt, title: "salt", clipOriginal: false))
        fields.append(DebugFormatted(base64EncodedString: self.keychainData, title: "keychainData", clipOriginal: true))

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModelV2.WalletInfoData.Relationships: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []
        mutableJSON.forEach { (tuple) in
            fields.append("\(tuple.key): \(tuple.value)")
        }

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModelV2.WalletInfoData.Relationships.KDF: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("type: \(self.type)")
        fields.append("id: \(self.id)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModelV2.WalletInfoData.Relationships.Factor: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("type: \(self.type)")
        fields.append("id: \(id)")
        fields.append("attributes: \(self.attributes.debugDescription)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModelV2.WalletInfoData.Relationships.Factor.Attributes: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("accountId: \(self.accountId)")
        fields.append(DebugFormatted(base64EncodedData: self.salt, title: "salt", clipOriginal: false))
        fields.append(DebugFormatted(base64EncodedString: self.keychainData, title: "keychainData", clipOriginal: true))

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModelV2.WalletInfoData.Relationships.Signer: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("type: \(self.type)")
        fields.append("id: \(id)")
        fields.append("attributes: \(self.attributes.debugDescription)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModelV2.WalletInfoData.Relationships.Signer.Attributes: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("role_id: \(self.roleId)")
        fields.append("weight: \(self.weight)")
        fields.append("identity: \(self.identity)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModelV2.WalletInfoData.Relationships.Transaction: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("attributes: \(self.attributes)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModelV2.WalletInfoData.Relationships.Transaction.Attributes: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("envelope: \(self.envelope)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

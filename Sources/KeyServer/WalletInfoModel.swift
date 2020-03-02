import Foundation

/// Wallet info model. Used wallet creation and update operations.
public struct WalletInfoModel: Encodable {
    
    public let data: WalletInfoData
    public let included: [Include]
    
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
            
            public let referrer: ApiDataRequest<Referrer, Include>?
            public let transaction: ApiDataRequest<Transaction, Include>?
            public let kdf: ApiDataRequest<KDF, Include>
            public let signers: ApiDataRequest<[Signer], Include>
            public let factor: ApiDataRequest<Factor, Include>
            
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

                public init(id: String, type: String, attributes: Attributes) {
                    self.attributes = attributes

                    super.init(id: id, type: type)
                }

                public let attributes: Attributes

                public struct Attributes: Encodable {

                    public let roleId: UInt64
                    public let weight: UInt64
                    public let identity: UInt64
                }

                public enum SignerIncludeKeys: CodingKey {
                    case attributes
                }

                override public func encode(to encoder: Encoder) throws {
                    try super.encode(to: encoder)
                    var container = encoder.container(keyedBy: SignerIncludeKeys.self)

                    try? container.encode(self.attributes, forKey: .attributes)
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
            
            public class Referrer: Include {
                
                public override init(id: String, type: String) {
                    super.init(id: id, type: type)
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

extension WalletInfoModel: CustomDebugStringConvertible {
    
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

extension WalletInfoModel.WalletInfoData.Attributes: CustomDebugStringConvertible {
    
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

extension WalletInfoModel.WalletInfoData.Relationships: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        if let referrer = self.referrer {
            fields.append("referrer: \(referrer.data.debugDescription)")
        }
        if let transaction = self.transaction {
            fields.append("transaction: \(transaction.data.debugDescription)")
        }
        fields.append("kdf: \(self.kdf.data.debugDescription)")
        fields.append("signers: \(self.signers.data.debugDescription)")
        fields.append("factor: \(self.factor.data.debugDescription)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.WalletInfoData.Relationships.KDF: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("type: \(self.type)")
        fields.append("id: \(self.id)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.WalletInfoData.Relationships.Factor: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("type: \(self.type)")
        fields.append("id: \(id)")
        fields.append("attributes: \(self.attributes.debugDescription)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.WalletInfoData.Relationships.Factor.Attributes: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("accountId: \(self.accountId)")
        fields.append(DebugFormatted(base64EncodedData: self.salt, title: "salt", clipOriginal: false))
        fields.append(DebugFormatted(base64EncodedString: self.keychainData, title: "keychainData", clipOriginal: true))
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.WalletInfoData.Relationships.Signer: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("type: \(self.type)")
        fields.append("id: \(id)")
        fields.append("attributes: \(self.attributes.debugDescription)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModel.WalletInfoData.Relationships.Signer.Attributes: CustomDebugStringConvertible {

    public var debugDescription: String {
        var fields: [String] = []

        fields.append("role_id: \(self.roleId)")
        fields.append("weight: \(self.weight)")
        fields.append("identity: \(self.identity)")

        let description = DebugFormattedDescription(fields)

        return description
    }
}

extension WalletInfoModel.WalletInfoData.Relationships.Referrer: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("type: \(self.type)")
        fields.append("id: \(self.id)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.WalletInfoData.Relationships.Transaction: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("attributes: \(self.attributes)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.WalletInfoData.Relationships.Transaction.Attributes: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("envelope: \(self.envelope)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

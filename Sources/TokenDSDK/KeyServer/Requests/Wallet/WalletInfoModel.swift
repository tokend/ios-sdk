import Foundation

/// Wallet info model. Used wallet creation and update operations.
public struct WalletInfoModel: Encodable {
    
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
        
        public let referrer: ApiDataRequest<Referrer>?
        public let transaction: ApiDataRequest<Transaction>?
        public let kdf: ApiDataRequest<KDF>
        public let recovery: ApiDataRequest<Factor>
        public let factor: ApiDataRequest<Factor>
        
        public struct Transaction: Encodable {
            
            public let attributes: Attributes
            
            public struct Attributes: Encodable {
                
                public let envelope: String
            }
        }
        
        public struct KDF: Encodable {
            
            public let type: String
            public let id: String
        }
        
        public struct Factor: Encodable {
            
            public let type: String
            public let id: String?
            public let attributes: Attributes
            
            public struct Attributes: Encodable {
                
                public let accountId: String
                public let keychainData: String
                public let salt: String
            }
        }
        
        public struct Referrer: Encodable {
            
            public let id: String
            public let type: Type
            
            public enum `Type`: String, Encodable {
                case referrer
            }
        }
    }
}

extension WalletInfoModel: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("type: \(self.type)")
        fields.append("id: \(self.id)")
        fields.append("attributes: \(self.attributes.debugDescription)")
        fields.append("relationships: \(self.relationships.debugDescription)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.Attributes: CustomDebugStringConvertible {
    
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

extension WalletInfoModel.Relationships: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        if let referrer = self.referrer {
            fields.append("referrer: \(referrer.data.debugDescription)")
        }
        if let transaction = self.transaction {
            fields.append("transaction: \(transaction.data.debugDescription)")
        }
        fields.append("kdf: \(self.kdf.data.debugDescription)")
        fields.append("recovery: \(self.recovery.data.debugDescription)")
        fields.append("factor: \(self.factor.data.debugDescription)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.Relationships.KDF: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("type: \(self.type)")
        fields.append("id: \(self.id)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.Relationships.Factor: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("type: \(self.type)")
        if let id = self.id {
            fields.append("id: \(id)")
        }
        fields.append("attributes: \(self.attributes.debugDescription)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.Relationships.Factor.Attributes: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("accountId: \(self.accountId)")
        fields.append(DebugFormatted(base64EncodedData: self.salt, title: "salt", clipOriginal: false))
        fields.append(DebugFormatted(base64EncodedString: self.keychainData, title: "keychainData", clipOriginal: true))
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.Relationships.Referrer: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("type: \(self.type.rawValue)")
        fields.append("id: \(self.id)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.Relationships.Transaction: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("attributes: \(self.attributes)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

extension WalletInfoModel.Relationships.Transaction.Attributes: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("envelope: \(self.envelope)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

import Foundation

public enum TFAFactorType: String {
    case password
    case totp
    case email
}

public struct TFAMetaResponse: Codable, CustomDebugStringConvertible {
    
    public let factorId: Int
    public let factorType: String
    public let keychainData: String?
    public let salt: String?
    public let token: String
    public let walletId: String
    
    public enum FactorTypeBase {
        case codeBased(TFACodeMetaModel)
        case passwordBased(TFAPasswordMetaModel)
    }
    
    public enum CodeBasedType {
        case totp
        case email
        case other(String)
    }
    
    // MARK: - Public
    
    static func getFactorTypeBase(_ meta: TFAMetaResponse) -> FactorTypeBase {
        switch meta.factorType {
        case "password":
            if let passwordMetaModel = TFAPasswordMetaModel.fromTFAMetaResponse(meta) {
                return .passwordBased(passwordMetaModel)
            } else {
                return .codeBased(TFACodeMetaModel.fromTFAMetaResponse(meta))
            }
        default:
            return .codeBased(TFACodeMetaModel.fromTFAMetaResponse(meta))
        }
    }
    
    public var factorTypeBase: FactorTypeBase {
        return TFAMetaResponse.getFactorTypeBase(self)
    }
    
    public var codeBasedType: CodeBasedType {
        switch self.factorType {
        case "totp":
            return .totp
        case "email":
            return .email
        default:
            return .other(self.factorType)
        }
    }
    
    // MARK: - CustomDebugStringConvertible
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("factorId: \(self.factorId)")
        fields.append("factorType: \(self.factorType)")
        if let keychainData = self.keychainData {
            fields.append("keychainData: \(keychainData)")
        }
        if let salt = self.salt {
            fields.append("salt: \(salt)")
        }
        fields.append("token: \(self.token)")
        fields.append("walletId: \(self.walletId)")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

public struct TFAFactor: Decodable {
    
    public let type: String
    public let id: Int
    public let attributes: Attributes
    
    public struct Attributes: Decodable {
        
        public let priority: Int
    }
}

/// TFA-related extensions to the list of `TFAFactor`
extension Array where Element == TFAFactor {
    
    /// Method returns totp factors
    public func getTOTPFactors() -> [TFAFactor] {
        return self.filter({ (factor) -> Bool in
            switch factor.type {
                
            case TFAFactorType.totp.rawValue:
                return true
                
            default:
                return false
            }
        })
    }
    
    /// Methods reports whether totp is enabled
    public func isTOTPEnabled() -> Bool {
        let totpPriority = self.getHighestPriority(factorType: TFAFactorType.totp.rawValue)
        
        for factor in self {
            switch factor.type {
                
            case TFAFactorType.totp.rawValue:
                continue
                
            default:
                if factor.attributes.priority > totpPriority {
                    return false
                }
            }
        }
        
        return totpPriority > 0
    }
    
    /// Method returns the highest priority of factorType
    /// - Parameters:
    ///   - factorType: Factor type for which priority should be returned
    public func getHighestPriority(factorType: String?) -> Int {
        var filtered = self
        
        if let factorType = factorType {
            filtered = self.filter({ $0.type == factorType })
        }
        
        let priority: Int = filtered.reduce(0, { (result, factor) -> Int in
            return Swift.max(result, factor.attributes.priority)
        })
        
        return priority
    }
}

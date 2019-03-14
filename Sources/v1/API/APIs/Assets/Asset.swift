import Foundation
import TokenDWallet

public struct Asset {
    
    // MARK: - Public properties
    
    public let availableForIssuance: Decimal
    public let code: String
    public let details: JSON
    public let issued: Decimal
    public let maxIssuanceAmount: Decimal
    public let owner: String
    public let pendingIssuance: Decimal
    public let policies: [PolicyStruct]?
    public let policy: Int
    public let preissuedAssetSigner: String
    public let type: Int
    
    // MARK: - Public
    
    public func meetsPolicy(_ policy: TokenDWallet.AssetPolicy) -> Bool {
        let containsPolicy = self.policies?.contains(where: { (policiesElement) -> Bool in
            return policy.rawValue == policiesElement.value
        })
        return containsPolicy ?? false
    }
    
    public var defaultDetails: Details? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self.details, options: []) else {
            return nil
        }
        
        return try? JSONDecoder().decode(Details.self, from: jsonData)
    }
    
    public func getDetails<DetailsType: Decodable>(_ type: DetailsType.Type) -> DetailsType? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self.details, options: []) else {
            return nil
        }
        
        return try? JSONDecoder().decode(DetailsType.self, from: jsonData)
    }
    
    public var typeValue: AssetType {
        guard let type = AssetType(rawValue: self.type) else {
            return .noRequirements
        }
        
        return type
    }
}

extension Asset {
    
    public enum AssetType: Int {
        case noRequirements = 0
        case requiresAccountApproved = 1
    }
}

extension Asset {
    
    public struct Details: Decodable {
        
        public let externalSystemType: Int32?
        public let logo: Logo?
        public let name: String?
        public let terms: Term?
    }
}

extension Asset.Details {
    
    public struct Logo: Decodable {
        
        public let key: String?
        public let type: String
        public let url: String?
    }
}

extension Asset.Details {
    
    public struct Term: Decodable {
        
        public let key: String
        public let name: String
        public let type: String
    }
}

extension Asset {
    public struct PolicyStruct: Decodable {
        
        public let name: String
        public let value: Int
    }
}

extension Asset: Decodable {
    enum CodingKeys: String, CodingKey {
        case availableForIssuance
        case code
        case details
        case issued
        case maxIssuanceAmount
        case owner
        case pendingIssuance
        case policies
        case policy
        case preissuedAssetSigner
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.availableForIssuance = try container.decodeDecimalString(key: .availableForIssuance)
        self.code = try container.decode(String.self, forKey: .code)
        self.details = try container.decodeDictionary(JSON.self, forKey: .details)
        self.issued = try container.decodeDecimalString(key: .issued)
        self.maxIssuanceAmount = try container.decodeDecimalString(key: .maxIssuanceAmount)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.pendingIssuance = try container.decodeDecimalString(key: .pendingIssuance)
        self.policies = try container.decodeIfPresent([PolicyStruct].self, forKey: .policies)
        self.policy = try container.decode(Int.self, forKey: .policy)
        self.preissuedAssetSigner = try container.decode(String.self, forKey: .preissuedAssetSigner)
        self.type = try container.decode(Int.self, forKey: .type)
    }
}

extension Asset.Details {
    enum CodingKeys: String, CodingKey {
        case externalSystemType
        case logo
        case name
        case terms
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let externalSystemTypeString = try container.decodeIfPresent(String.self, forKey: .externalSystemType)
        if let externalSystemTypeString = externalSystemTypeString,
            externalSystemTypeString.isEmpty == false {
            guard let type = Int32(externalSystemTypeString) else {
                throw DecodingError.dataCorruptedError(
                    forKey: CodingKeys.externalSystemType,
                    in: container,
                    debugDescription: "Cannot get Int32 from String \(externalSystemTypeString)"
                )
            }
            self.externalSystemType = type
        } else {
            self.externalSystemType = nil
        }
        
        self.logo = try container.decodeIfPresent(Logo.self, forKey: .logo)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.terms = try container.decodeIfPresent(Term.self, forKey: .terms)
    }
}

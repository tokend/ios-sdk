import Foundation
import TokenDWallet

public struct Asset {
    
    public let code: String
    public let owner: String
    public let availableForIssuance: Decimal
    public let preissuedAssetSigner: String
    public let maxIssuanceAmount: Decimal
    public let issued: Decimal
    public let pendingIssuance: Decimal
    public let policy: Int
    private let policies: [PolicyStruct]?
    public let details: Details
    
    public func meetsPolicy(_ policy: TokenDWallet.AssetPolicy) -> Bool {
        let containsPolicy = self.policies?.contains(where: { (policiesElement) -> Bool in
            return policy.rawValue == policiesElement.value
        })
        return containsPolicy ?? false
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
    private struct PolicyStruct: Decodable {
        
        let name: String
        let value: Int
    }
}

extension Asset: Decodable {
    enum CodingKeys: String, CodingKey {
        case code
        case owner
        case availableForIssuance
        case preissuedAssetSigner
        case maxIssuanceAmount
        case issued
        case pendingIssuance
        case policy
        case policies
        case details
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.issued = try container.decodeDecimalString(key: .issued)
        self.availableForIssuance = try container.decodeDecimalString(key: .availableForIssuance)
        self.maxIssuanceAmount = try container.decodeDecimalString(key: .maxIssuanceAmount)
        self.pendingIssuance = try container.decodeDecimalString(key: .pendingIssuance)
        self.code = try container.decode(String.self, forKey: .code)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.preissuedAssetSigner = try container.decode(String.self, forKey: .preissuedAssetSigner)
        self.policy = try container.decode(Int.self, forKey: .policy)
        self.policies = try container.decodeIfPresent([PolicyStruct].self, forKey: .policies)
        self.details = try container.decode(Details.self, forKey: .details)
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

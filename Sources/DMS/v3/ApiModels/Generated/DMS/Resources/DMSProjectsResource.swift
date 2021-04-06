// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ProjectsResource

extension DMS {
open class ProjectsResource: Resource {
    
    open override class var resourceType: String {
        return "projects"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case address
        case city
        case code
        case country
        case description
        case estEndDate
        case fax
        case logo
        case name
        case phone
        case postcode
        case shortName
        case startDate
        case state
        case type
        case valueUsd
    }
    
    // MARK: Attributes
    
    open var address: String {
        return self.stringOptionalValue(key: CodingKeys.address) ?? ""
    }
    
    open var city: String {
        return self.stringOptionalValue(key: CodingKeys.city) ?? ""
    }
    
    open var code: String {
        return self.stringOptionalValue(key: CodingKeys.code) ?? ""
    }
    
    open var country: String {
        return self.stringOptionalValue(key: CodingKeys.country) ?? ""
    }
    
    open var description: String {
        return self.stringOptionalValue(key: CodingKeys.description) ?? ""
    }
    
    open var estEndDate: Date {
        return self.dateOptionalValue(key: CodingKeys.estEndDate) ?? Date()
    }
    
    open var fax: String {
        return self.stringOptionalValue(key: CodingKeys.fax) ?? ""
    }
    
    open var logo: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.logo) ?? [:]
    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
    open var phone: String {
        return self.stringOptionalValue(key: CodingKeys.phone) ?? ""
    }
    
    open var postcode: String {
        return self.stringOptionalValue(key: CodingKeys.postcode) ?? ""
    }
    
    open var shortName: String {
        return self.stringOptionalValue(key: CodingKeys.shortName) ?? ""
    }
    
    open var startDate: Date {
        return self.dateOptionalValue(key: CodingKeys.startDate) ?? Date()
    }
    
    open var state: String {
        return self.stringOptionalValue(key: CodingKeys.state) ?? ""
    }
    
    open var attributesType: String {
        return self.stringOptionalValue(key: CodingKeys.type) ?? ""
    }
    
    open var valueUsd: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.valueUsd) ?? 0.0
    }
    
}
}

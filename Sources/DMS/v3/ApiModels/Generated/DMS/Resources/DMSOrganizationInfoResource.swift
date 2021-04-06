// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OrganizationInfoResource

extension DMS {
open class OrganizationInfoResource: Resource {
    
    open override class var resourceType: String {
        return "organization_info"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case companyRegistrationNo
        case deliveryAddress
        case deliveryCity
        case deliveryCode
        case deliveryCountry
        case deliveryState
        case emailAddress
        case fax
        case logo
        case organizationAbbrev
        case organizationAdmins
        case organizationName
        case phone
        case postalAddress
        case postalCity
        case postalCode
        case postalCountry
        case postalState
        case tradingName
        case website
    }
    
    // MARK: Attributes
    
    open var companyRegistrationNo: String? {
        return self.stringOptionalValue(key: CodingKeys.companyRegistrationNo)
    }
    
    open var deliveryAddress: String? {
        return self.stringOptionalValue(key: CodingKeys.deliveryAddress)
    }
    
    open var deliveryCity: String? {
        return self.stringOptionalValue(key: CodingKeys.deliveryCity)
    }
    
    open var deliveryCode: String? {
        return self.stringOptionalValue(key: CodingKeys.deliveryCode)
    }
    
    open var deliveryCountry: String? {
        return self.stringOptionalValue(key: CodingKeys.deliveryCountry)
    }
    
    open var deliveryState: String? {
        return self.stringOptionalValue(key: CodingKeys.deliveryState)
    }
    
    open var emailAddress: String? {
        return self.stringOptionalValue(key: CodingKeys.emailAddress)
    }
    
    open var fax: String? {
        return self.stringOptionalValue(key: CodingKeys.fax)
    }
    
    open var logo: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.logo) ?? [:]
    }
    
    open var organizationAbbrev: String? {
        return self.stringOptionalValue(key: CodingKeys.organizationAbbrev)
    }
    
    open var organizationAdmins: DMS.OrganizationAdmin? {
        return self.codableOptionalValue(key: CodingKeys.organizationAdmins)
    }
    
    open var organizationName: String? {
        return self.stringOptionalValue(key: CodingKeys.organizationName)
    }
    
    open var phone: String? {
        return self.stringOptionalValue(key: CodingKeys.phone)
    }
    
    open var postalAddress: String? {
        return self.stringOptionalValue(key: CodingKeys.postalAddress)
    }
    
    open var postalCity: String? {
        return self.stringOptionalValue(key: CodingKeys.postalCity)
    }
    
    open var postalCode: String? {
        return self.stringOptionalValue(key: CodingKeys.postalCode)
    }
    
    open var postalCountry: String? {
        return self.stringOptionalValue(key: CodingKeys.postalCountry)
    }
    
    open var postalState: String? {
        return self.stringOptionalValue(key: CodingKeys.postalState)
    }
    
    open var tradingName: String? {
        return self.stringOptionalValue(key: CodingKeys.tradingName)
    }
    
    open var website: String? {
        return self.stringOptionalValue(key: CodingKeys.website)
    }
    
}
}

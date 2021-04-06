// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - UserResource

extension DMS {
open class UserResource: Resource {
    
    open override class var resourceType: String {
        return "user"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case address
        case city
        case country
        case currentProjectId
        case division
        case email
        case fax
        case firstName
        case jobFunction
        case jobTitle
        case kycRecoveryStatus
        case lastName
        case logo
        case middleName
        case mobile
        case phone
        case postcode
        case role
        case state
        case status
        case title
        
        // relations
        case projects
    }
    
    // MARK: Attributes
    
    open var address: String {
        return self.stringOptionalValue(key: CodingKeys.address) ?? ""
    }
    
    open var city: String {
        return self.stringOptionalValue(key: CodingKeys.city) ?? ""
    }
    
    open var country: String {
        return self.stringOptionalValue(key: CodingKeys.country) ?? ""
    }
    
    open var currentProjectId: String {
        return self.stringOptionalValue(key: CodingKeys.currentProjectId) ?? ""
    }
    
    open var division: String {
        return self.stringOptionalValue(key: CodingKeys.division) ?? ""
    }
    
    open var email: String {
        return self.stringOptionalValue(key: CodingKeys.email) ?? ""
    }
    
    open var fax: String {
        return self.stringOptionalValue(key: CodingKeys.fax) ?? ""
    }
    
    open var firstName: String {
        return self.stringOptionalValue(key: CodingKeys.firstName) ?? ""
    }
    
    open var jobFunction: String {
        return self.stringOptionalValue(key: CodingKeys.jobFunction) ?? ""
    }
    
    open var jobTitle: String {
        return self.stringOptionalValue(key: CodingKeys.jobTitle) ?? ""
    }
    
    open var kycRecoveryStatus: Int32 {
        return self.int32OptionalValue(key: CodingKeys.kycRecoveryStatus) ?? 0
    }
    
    open var lastName: String {
        return self.stringOptionalValue(key: CodingKeys.lastName) ?? ""
    }
    
    open var logo: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.logo)
    }
    
    open var middleName: String {
        return self.stringOptionalValue(key: CodingKeys.middleName) ?? ""
    }
    
    open var mobile: String {
        return self.stringOptionalValue(key: CodingKeys.mobile) ?? ""
    }
    
    open var phone: String {
        return self.stringOptionalValue(key: CodingKeys.phone) ?? ""
    }
    
    open var postcode: String {
        return self.stringOptionalValue(key: CodingKeys.postcode) ?? ""
    }
    
    open var role: String {
        return self.stringOptionalValue(key: CodingKeys.role) ?? ""
    }
    
    open var state: String {
        return self.stringOptionalValue(key: CodingKeys.state) ?? ""
    }
    
    open var status: Int32 {
        return self.int32OptionalValue(key: CodingKeys.status) ?? 0
    }
    
    open var title: String {
        return self.stringOptionalValue(key: CodingKeys.title) ?? ""
    }
    
    // MARK: Relations
    
    open var projects: [DMS.ProjectsResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.projects)
    }
    
}
}

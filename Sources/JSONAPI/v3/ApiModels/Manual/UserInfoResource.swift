import Foundation
import DLJSONAPI

// MARK: - UserInfoResource

open class UserInfoResource: Resource {

    open override class var resourceType: String {
        return "users-info"
    }

    public enum CodingKeys: String, CodingKey {
        // attributes
        case documents
        case firstName
        case lastName
    }

    // MARK: - Attributes

    open var documents: [String: Any] {
        get { return self.dictionaryOptionalValue(key: CodingKeys.documents) ?? [:] }
        set { self.setDictionaryOptionalValue(newValue, key: CodingKeys.documents) }
    }

    open var firstName: String {
        get { return self.stringOptionalValue(key: CodingKeys.firstName) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.firstName) }
    }

    open var lastName: String {
        get { return self.stringOptionalValue(key: CodingKeys.lastName) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.lastName) }
    }
}

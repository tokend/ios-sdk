// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AccountTestTypeResource

extension MunaTestResults {
open class AccountTestTypeResource: Resource {
    
    open override class var resourceType: String {
        return "account_test_type"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case account
        case testTypeId
        
        // relations
        case creator
    }
    
    // MARK: Attributes
    
    open var account: String {
        return self.stringOptionalValue(key: CodingKeys.account) ?? ""
    }
    
    open var testTypeId: Int32 {
        return self.int32OptionalValue(key: CodingKeys.testTypeId) ?? 0
    }
    
    // MARK: Relations
    
    open var creator: MunaTestResults.TestTypeResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.creator)
    }
    
}
}

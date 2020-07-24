// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageAccountSpecificRuleOpResource

extension Horizon {
open class ManageAccountSpecificRuleOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-account-specific-rule"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case createData
        
        // relations
        case rule
    }
    
    // MARK: Attributes
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var createData: Horizon.CreateAccountSpecificRuleData? {
        return self.codableOptionalValue(key: CodingKeys.createData)
    }
    
    // MARK: Relations
    
    open var rule: Horizon.AccountSpecificRuleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.rule)
    }
    
}
}

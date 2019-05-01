// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpStamlDetailsResource

open class OpStamlDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-stamp"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case ledgerHash
        case licenseHash
    }
    
    // MARK: Attributes
    
    open var ledgerHash: String {
        return self.stringOptionalValue(key: CodingKeys.ledgerHash) ?? ""
    }
    
    open var licenseHash: String {
        return self.stringOptionalValue(key: CodingKeys.licenseHash) ?? ""
    }
    
}

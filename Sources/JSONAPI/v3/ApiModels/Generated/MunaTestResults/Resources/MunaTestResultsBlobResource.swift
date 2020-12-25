// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - BlobResource

extension MunaTestResults {
open class BlobResource: Resource {
    
    open override class var resourceType: String {
        return "base-blob"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case value
    }
    
    // MARK: Attributes
    
    open var value: String {
        return self.stringOptionalValue(key: CodingKeys.value) ?? ""
    }
    
}
}

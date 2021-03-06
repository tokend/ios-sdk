// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - TestResource

extension MunaTestResults {
open class TestResource: Resource {
    
    open override class var resourceType: String {
        return "tests"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case blobId
        case value
        
        // relations
        case creator
        case participant
    }
    
    // MARK: Attributes
    
    open var blobId: String {
        return self.stringOptionalValue(key: CodingKeys.blobId) ?? ""
    }
    
    open var value: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.value) ?? [:]
    }
    
    // MARK: Relations
    
    open var creator: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.creator)
    }
    
    open var participant: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.participant)
    }
    
}
}

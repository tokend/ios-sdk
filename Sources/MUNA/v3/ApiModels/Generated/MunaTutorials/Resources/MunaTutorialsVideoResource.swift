// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - VideoResource

extension MunaTutorials {
open class VideoResource: Resource {
    
    open override class var resourceType: String {
        return "video"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case category
        case name
        case url
    }
    
    // MARK: Attributes
    
    open var category: String {
        return self.stringOptionalValue(key: CodingKeys.category) ?? ""
    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
    open var url: String {
        return self.stringOptionalValue(key: CodingKeys.url) ?? ""
    }
    
}
}

// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ReactionResource

extension Nifty {
open class ReactionResource: Resource {
    
    open override class var resourceType: String {
        return "reaction"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case reaction
        case title
    }
    
    // MARK: Attributes
    
    open var reaction: String {
        return self.stringOptionalValue(key: CodingKeys.reaction) ?? ""
    }
    
    open var title: Nifty.TitleResource? {
        return self.value(forKey: CodingKeys.title) as? Nifty.TitleResource
    }
    
}
}

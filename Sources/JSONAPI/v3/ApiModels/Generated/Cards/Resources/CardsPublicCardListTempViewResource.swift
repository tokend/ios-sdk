// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - PublicCardListTempViewResource

extension Cards {
open class PublicCardListTempViewResource: Resource {
    
    open override class var resourceType: String {
        return "public-card-list-temp-view"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case owners
    }
    
    // MARK: Relations
    
    open var owners: [Resource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.owners)
    }
    
}
}

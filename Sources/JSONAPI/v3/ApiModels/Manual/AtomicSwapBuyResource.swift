import Foundation
import DLJSONAPI

// MARK: - BusinessResource

open class AtomicSwapBuyResource: Resource {
    
    open override class var resourceType: String {
        return ""
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case type
        case data
    }
    
    // MARK: Attributes
    
    open var paymentType: String {
        get { return self.stringOptionalValue(key: CodingKeys.type) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.type) }
    }
    
    open var data: [String: Any] {
        get { return self.dictionaryOptionalValue(key: CodingKeys.data) ?? [:] }
        set { self.setDictionaryOptionalValue(newValue, key: CodingKeys.data) }
    }
}

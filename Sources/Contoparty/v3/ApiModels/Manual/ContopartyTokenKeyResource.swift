import Foundation
import DLJSONAPI

extension Contoparty {
    open class ContopartyTokenKeyResource: Resource {
        
        open override class var resourceType: String {
            return "transactions"
        }
        
        public enum CodingKeys: String, CodingKey {
            case id
        }
        
        // MARK: Relations
        
        open var tokenId: Int {
            return self.intOptionalValue(key: CodingKeys.id) ?? 0
        }
    }
}

import Foundation
import DLJSONAPI

extension Contoparty {
    open class ContopartyMintTokenResource: Resource {
        
        open override class var resourceType: String {
            return "transactions"
        }
        
        public enum CodingKeys: String, CodingKey {
            // attributes
            case hash
            case envelopeXdr
            
            // relations
            case mintedTokens
        }
        
        // MARK: Attributes
        
        open var hash: String {
            return self.stringOptionalValue(key: CodingKeys.hash) ?? ""
        }
        
        open var envelopeXdr: String {
            return self.stringOptionalValue(key: CodingKeys.envelopeXdr) ?? ""
        }
        
        // MARK: Relations
        
        open var mintedTokens: [Resource]? {
            return self.relationCollectionOptionalValue(key: CodingKeys.mintedTokens)
        }
    }
}

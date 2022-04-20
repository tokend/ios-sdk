// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - TransactionResource

extension Horizon {
open class TransactionResource: Resource {
    
    open override class var resourceType: String {
        return "transactions"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case createdAt
        case envelopeXdr
        case hash
        case ledgerSequence
        case resultMetaXdr
        case resultXdr
        
        // relations
        case ledgerEntryChanges
        case operations
        case source
#if TOKENDSDK_CONTOPARTYAPI
        case mintedTokens
#endif
        
    }
    
    // MARK: Attributes
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var envelopeXdr: String {
        return self.stringOptionalValue(key: CodingKeys.envelopeXdr) ?? ""
    }
    
    open var hash: String {
        return self.stringOptionalValue(key: CodingKeys.hash) ?? ""
    }
    
    open var ledgerSequence: Int32 {
        return self.int32OptionalValue(key: CodingKeys.ledgerSequence) ?? 0
    }
    
    open var resultMetaXdr: String {
        return self.stringOptionalValue(key: CodingKeys.resultMetaXdr) ?? ""
    }
    
    open var resultXdr: String {
        return self.stringOptionalValue(key: CodingKeys.resultXdr) ?? ""
    }
    
    // MARK: Relations
    
    open var ledgerEntryChanges: [Horizon.LedgerEntryChangeResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.ledgerEntryChanges)
    }
    
    open var operations: [Horizon.OperationResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.operations)
    }
    
    open var source: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.source)
    }
    
#if TOKENDSDK_CONTOPARTYAPI
    open var mintedTokens: [Resource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.mintedTokens)
    }
#endif
}
}

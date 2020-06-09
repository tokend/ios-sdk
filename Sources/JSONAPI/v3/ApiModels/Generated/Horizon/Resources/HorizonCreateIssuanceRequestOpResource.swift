// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateIssuanceRequestOpResource

extension Horizon {
open class CreateIssuanceRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-issuance-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case allTasks
        case amount
        case creatorDetails
        case fee
        case reference
        
        // relations
        case asset
        case receiverAccount
        case receiverBalance
        case request
    }
    
    // MARK: Attributes
    
    open var allTasks: Int64? {
        return self.int64OptionalValue(key: CodingKeys.allTasks)
    }
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var fee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.fee)
    }
    
    open var reference: String {
        return self.stringOptionalValue(key: CodingKeys.reference) ?? ""
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var receiverAccount: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.receiverAccount)
    }
    
    open var receiverBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.receiverBalance)
    }
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}

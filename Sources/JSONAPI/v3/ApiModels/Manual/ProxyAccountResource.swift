import Foundation
import DLJSONAPI

// MARK: - BusinessResource

open class PaymentAccountResource: Resource {
    
    open override class var resourceType: String {
        return "payment-account"
    }
}

import Foundation

public struct TransactionsPaymentsRequestParameters: Encodable {
    public let asset: String?
    public let cursor: String?
    public let order: String?
    public let limit: Int?
    public let completedOnly: Bool?
    
    public init(
        asset: String?,
        cursor: String?,
        order: String?,
        limit: Int?,
        completedOnly: Bool?
        ) {
        
        self.asset = asset
        self.cursor = cursor
        self.order = order
        self.limit = limit
        self.completedOnly = completedOnly
    }
}

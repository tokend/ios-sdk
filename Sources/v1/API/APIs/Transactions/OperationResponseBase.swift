import Foundation

public class OperationResponseBase {
    
    public let originalResponse: OperationResponseUnified
    public let amount: Decimal
    public let asset: String
    public let id: UInt64
    public let ledgerCloseTime: Date
    public let pagingToken: String
    public let state: String
    public let stateValue: OperationResponseUnified.OperationState
    public let type: String
    public let typeValue: OperationResponseUnified.OperationType
    
    // MARK: -
    
    public required init?(from unified: OperationResponseUnified) {
        self.originalResponse = unified
        self.amount = unified.amount ?? 0
        self.asset = unified.asset ?? ""
        self.id = unified.id
        self.ledgerCloseTime = unified.ledgerCloseTime
        self.pagingToken = unified.pagingToken
        self.state = unified.state
        self.stateValue = unified.stateValue
        self.type = unified.type
        self.typeValue = unified.typeValue
    }
}

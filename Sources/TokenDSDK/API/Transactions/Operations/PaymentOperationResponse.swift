import Foundation

public final class PaymentOperationResponse: OperationResponseBase {
    
    public let destinationFixedFee: Decimal
    public let destinationPaymentFee: Decimal
    public let fromAccountId: String
    public let fromBalanceId: String
    public let sourceFixedFee: Decimal
    public let sourcePaymentFee: Decimal
    public let sourcePaysForDest: Bool
    public let subject: String?
    public let toAccountId: String
    public let toBalanceId: String
    
    // MARK: -
    
    public required init?(from unified: OperationResponseUnified) {
        guard
            let destinationFixedFee = unified.destinationFixedFee,
            let destinationPaymentFee = unified.destinationPaymentFee,
            let fromAccountId = unified.from,
            let fromBalanceId = unified.fromBalance,
            let sourceFixedFee = unified.sourceFixedFee,
            let sourcePaymentFee = unified.sourcePaymentFee,
            let sourcePaysForDest = unified.sourcePaysForDest,
            let toAccountId = unified.to,
            let toBalanceId = unified.toBalance
            else {
                return nil
        }
        
        self.destinationFixedFee = destinationFixedFee
        self.destinationPaymentFee = destinationPaymentFee
        self.fromAccountId = fromAccountId
        self.fromBalanceId = fromBalanceId
        self.sourceFixedFee = sourceFixedFee
        self.sourcePaymentFee = sourcePaymentFee
        self.sourcePaysForDest = sourcePaysForDest
        self.subject = unified.subject
        self.toAccountId = toAccountId
        self.toBalanceId = toBalanceId
        
        super.init(from: unified)
    }
}

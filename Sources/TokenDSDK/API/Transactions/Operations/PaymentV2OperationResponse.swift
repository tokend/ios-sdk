import Foundation

public final class PaymentV2OperationResponse: OperationResponseBase {
    
    public let destinationFeeData: FeeData
    public let fromAccountId: String
    public let fromBalanceId: String
    public let participants: [Participant]
    public let sourceFeeData: FeeData
    public let sourcePaysForDest: Bool
    public let subject: String?
    public let toAccountId: String
    public let toBalanceId: String
    
    // MARK: -
    
    required public init?(from unified: OperationResponseUnified) {
        guard
            let destinationFeeData = unified.destinationFeeData,
            let fromAccountId = unified.from,
            let fromBalanceId = unified.fromBalance,
            let sourceFeeData = unified.sourceFeeData,
            let sourcePaysForDest = unified.sourcePaysForDest,
            let toAccountId = unified.to,
            let toBalanceId = unified.toBalance
            else {
                return nil
        }
        
        self.destinationFeeData = FeeData(destinationFeeData)
        self.fromAccountId = fromAccountId
        self.fromBalanceId = fromBalanceId
        self.participants = unified.participantsChecked.compactMap({ (participant) -> Participant? in
            return Participant(participant)
        })
        self.sourceFeeData = FeeData(sourceFeeData)
        self.sourcePaysForDest = sourcePaysForDest
        self.subject = unified.subject
        self.toAccountId = toAccountId
        self.toBalanceId = toBalanceId
        
        super.init(from: unified)
    }
}

extension PaymentV2OperationResponse {
    
    public struct Participant {
        
        public let accountId: String
        public let balanceId: String
        
        public init?(_ unified: OperationResponseUnified.Participant) {
            guard
                let accountId = unified.accountId,
                let balanceId = unified.balanceId
                else {
                    return nil
            }
            
            self.accountId = accountId
            self.balanceId = balanceId
        }
    }
}

extension PaymentV2OperationResponse {
    
    public struct FeeData {
        
        public let actualPaymentFee: Decimal
        public let actualPaymentFeeAssetCode: String
        public let fixedFee: Decimal
        
        public init(_ unified: OperationResponseUnified.FeeData) {
            self.actualPaymentFee = unified.actualPaymentFee
            self.actualPaymentFeeAssetCode = unified.actualPaymentFeeAssetCode
            self.fixedFee = unified.fixedFee
        }
    }
}

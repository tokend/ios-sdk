import Foundation

public final class CreateWithdrawalRequest: OperationResponseBase {
    
    public let destAmount: Decimal
    public let destAsset: String
    public let externalDetails: ExternalDetails?
    public let feeFixed: Decimal
    public let feePercent: Decimal
    public let identifier: String
    
    public required init?(from unified: OperationResponseUnified) {
        guard
            let destAmount = unified.destAmount,
            let destAsset = unified.destAsset,
            let feeFixed = unified.feeFixed,
            let feePercent = unified.feePercent
            else {
                return nil
        }
        
        self.destAmount = destAmount
        self.destAsset = destAsset
        if let address = unified.externalDetails?.address {
            self.externalDetails = ExternalDetails(address: address)
        } else {
            self.externalDetails = nil
        }
        self.feeFixed = feeFixed
        self.feePercent = feePercent
        self.identifier = unified.identifier
        
        super.init(from: unified)
    }
}

extension CreateWithdrawalRequest {
    
    public struct ExternalDetails {
        
        public let address: String
    }
}

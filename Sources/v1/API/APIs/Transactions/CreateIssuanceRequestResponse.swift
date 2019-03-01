import Foundation

public final class CreateIssuanceRequestResponse: OperationResponseBase {
    
    public let externalDetails: ExternalDetails?
    public let reference: String
    
    // MARK: -
    
    public required init?(from unified: OperationResponseUnified) {
        if let externalDetails = unified.externalDetails,
            let details = ExternalDetails(externalDetails) {
            self.externalDetails = details
        } else {
            self.externalDetails = nil
        }
        
        guard let reference = unified.reference else {
            return nil
        }
        self.reference = reference
        
        super.init(from: unified)
    }
}

extension CreateIssuanceRequestResponse {
    
    public struct ExternalDetails {
        
        private let cause: String
        public var causeValue: Cause? {
            return Cause(rawValue: self.cause)
        }
        
        public init?(_ unified: OperationResponseUnified.ExternalDetails) {
            guard
                let cause = unified.cause
                else {
                    return nil
            }
            
            self.cause = cause
        }
    }
}

extension CreateIssuanceRequestResponse.ExternalDetails {
    
    public enum Cause: String {
        case airdrop
        case airdropForKYC = "airdropforkyc"
    }
}

// Auto-generated code. Do not edit.

import Foundation

public enum OperationDetailsType {
    
    case opBindExternalSystemAccountDetails(_ resource: OpBindExternalSystemAccountDetailsResource)
    case opCancelAtomicSwapBidDetails(_ resource: OpCancelAtomicSwapBidDetailsResource)
    case opCheckSaleStateDetails(_ resource: OpCheckSaleStateDetailsResource)
    case opCreateAMLAlertRequestDetails(_ resource: OpCreateAMLAlertRequestDetailsResource)
    case opCreateAccountDetails(_ resource: OpCreateAccountDetailsResource)
    case opCreateAtomicSwapBidRequestDetails(_ resource: OpCreateAtomicSwapBidRequestDetailsResource)
    case opCreateChangeRoleRequestDetails(_ resource: OpCreateChangeRoleRequestDetailsResource)
    case opCreateIssuanceRequestDetails(_ resource: OpCreateIssuanceRequestDetailsResource)
    case opCreateManageLimitsRequestDetails(_ resource: OpCreateManageLimitsRequestDetailsResource)
    case opCreatePreIssuanceRequestDetails(_ resource: OpCreatePreIssuanceRequestDetailsResource)
    case opCreateSaleRequestDetails(_ resource: OpCreateSaleRequestDetailsResource)
    case opCreateWithdrawRequestDetails(_ resource: OpCreateWithdrawRequestDetailsResource)
    case opLicenseDetails(_ resource: OpLicenseDetailsResource)
    case opManageAccountRoleDetails(_ resource: OpManageAccountRoleDetailsResource)
    case opManageAccountRuleDetails(_ resource: OpManageAccountRuleDetailsResource)
    case opManageAssetDetails(_ resource: OpManageAssetDetailsResource)
    case opManageAssetPairDetails(_ resource: OpManageAssetPairDetailsResource)
    case opManageBalanceDetails(_ resource: OpManageBalanceDetailsResource)
    case opManageExternalSystemPoolDetails(_ resource: OpManageExternalSystemPoolDetailsResource)
    case opManageKeyValueDetails(_ resource: OpManageKeyValueDetailsResource)
    case opManageLimitsDetails(_ resource: OpManageLimitsDetailsResource)
    case opManageOfferDetails(_ resource: OpManageOfferDetailsResource)
    case opManageSaleDetails(_ resource: OpManageSaleDetailsResource)
    case opManageSignerDetails(_ resource: OpManageSignerDetailsResource)
    case opManageSignerRoleDetails(_ resource: OpManageSignerRoleDetailsResource)
    case opManageSignerRuleDetails(_ resource: OpManageSignerRuleDetailsResource)
    case opPaymentDetails(_ resource: OpPaymentDetailsResource)
    case opPayoutDetails(_ resource: OpPayoutDetailsResource)
    case opReviewRequestDetails(_ resource: OpReviewRequestDetailsResource)
    case opSetFeeDetails(_ resource: OpSetFeeDetailsResource)
    case opStamlDetails(_ resource: OpStamlDetailsResource)
    case `self`(_ resource: OperationDetailsResource)
}

extension OperationDetailsResource {
    
    public var operationDetailsType: OperationDetailsType {
        if let resource = self as? OpBindExternalSystemAccountDetailsResource {
            return .opBindExternalSystemAccountDetails(resource)
        } else if let resource = self as? OpCancelAtomicSwapBidDetailsResource {
            return .opCancelAtomicSwapBidDetails(resource)
        } else if let resource = self as? OpCheckSaleStateDetailsResource {
            return .opCheckSaleStateDetails(resource)
        } else if let resource = self as? OpCreateAMLAlertRequestDetailsResource {
            return .opCreateAMLAlertRequestDetails(resource)
        } else if let resource = self as? OpCreateAccountDetailsResource {
            return .opCreateAccountDetails(resource)
        } else if let resource = self as? OpCreateAtomicSwapBidRequestDetailsResource {
            return .opCreateAtomicSwapBidRequestDetails(resource)
        } else if let resource = self as? OpCreateChangeRoleRequestDetailsResource {
            return .opCreateChangeRoleRequestDetails(resource)
        } else if let resource = self as? OpCreateIssuanceRequestDetailsResource {
            return .opCreateIssuanceRequestDetails(resource)
        } else if let resource = self as? OpCreateManageLimitsRequestDetailsResource {
            return .opCreateManageLimitsRequestDetails(resource)
        } else if let resource = self as? OpCreatePreIssuanceRequestDetailsResource {
            return .opCreatePreIssuanceRequestDetails(resource)
        } else if let resource = self as? OpCreateSaleRequestDetailsResource {
            return .opCreateSaleRequestDetails(resource)
        } else if let resource = self as? OpCreateWithdrawRequestDetailsResource {
            return .opCreateWithdrawRequestDetails(resource)
        } else if let resource = self as? OpLicenseDetailsResource {
            return .opLicenseDetails(resource)
        } else if let resource = self as? OpManageAccountRoleDetailsResource {
            return .opManageAccountRoleDetails(resource)
        } else if let resource = self as? OpManageAccountRuleDetailsResource {
            return .opManageAccountRuleDetails(resource)
        } else if let resource = self as? OpManageAssetDetailsResource {
            return .opManageAssetDetails(resource)
        } else if let resource = self as? OpManageAssetPairDetailsResource {
            return .opManageAssetPairDetails(resource)
        } else if let resource = self as? OpManageBalanceDetailsResource {
            return .opManageBalanceDetails(resource)
        } else if let resource = self as? OpManageExternalSystemPoolDetailsResource {
            return .opManageExternalSystemPoolDetails(resource)
        } else if let resource = self as? OpManageKeyValueDetailsResource {
            return .opManageKeyValueDetails(resource)
        } else if let resource = self as? OpManageLimitsDetailsResource {
            return .opManageLimitsDetails(resource)
        } else if let resource = self as? OpManageOfferDetailsResource {
            return .opManageOfferDetails(resource)
        } else if let resource = self as? OpManageSaleDetailsResource {
            return .opManageSaleDetails(resource)
        } else if let resource = self as? OpManageSignerDetailsResource {
            return .opManageSignerDetails(resource)
        } else if let resource = self as? OpManageSignerRoleDetailsResource {
            return .opManageSignerRoleDetails(resource)
        } else if let resource = self as? OpManageSignerRuleDetailsResource {
            return .opManageSignerRuleDetails(resource)
        } else if let resource = self as? OpPaymentDetailsResource {
            return .opPaymentDetails(resource)
        } else if let resource = self as? OpPayoutDetailsResource {
            return .opPayoutDetails(resource)
        } else if let resource = self as? OpReviewRequestDetailsResource {
            return .opReviewRequestDetails(resource)
        } else if let resource = self as? OpSetFeeDetailsResource {
            return .opSetFeeDetails(resource)
        } else if let resource = self as? OpStamlDetailsResource {
            return .opStamlDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opBindExternalSystemAccountDetails(let resource):
        
        
    case .opCancelAtomicSwapBidDetails(let resource):
        
        
    case .opCheckSaleStateDetails(let resource):
        
        
    case .opCreateAMLAlertRequestDetails(let resource):
        
        
    case .opCreateAccountDetails(let resource):
        
        
    case .opCreateAtomicSwapBidRequestDetails(let resource):
        
        
    case .opCreateChangeRoleRequestDetails(let resource):
        
        
    case .opCreateIssuanceRequestDetails(let resource):
        
        
    case .opCreateManageLimitsRequestDetails(let resource):
        
        
    case .opCreatePreIssuanceRequestDetails(let resource):
        
        
    case .opCreateSaleRequestDetails(let resource):
        
        
    case .opCreateWithdrawRequestDetails(let resource):
        
        
    case .opLicenseDetails(let resource):
        
        
    case .opManageAccountRoleDetails(let resource):
        
        
    case .opManageAccountRuleDetails(let resource):
        
        
    case .opManageAssetDetails(let resource):
        
        
    case .opManageAssetPairDetails(let resource):
        
        
    case .opManageBalanceDetails(let resource):
        
        
    case .opManageExternalSystemPoolDetails(let resource):
        
        
    case .opManageKeyValueDetails(let resource):
        
        
    case .opManageLimitsDetails(let resource):
        
        
    case .opManageOfferDetails(let resource):
        
        
    case .opManageSaleDetails(let resource):
        
        
    case .opManageSignerDetails(let resource):
        
        
    case .opManageSignerRoleDetails(let resource):
        
        
    case .opManageSignerRuleDetails(let resource):
        
        
    case .opPaymentDetails(let resource):
        
        
    case .opPayoutDetails(let resource):
        
        
    case .opReviewRequestDetails(let resource):
        
        
    case .opSetFeeDetails(let resource):
        
        
    case .opStamlDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/

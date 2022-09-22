// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsType {
    
    case bindExternalSystemAccountIdOp(_ resource: Horizon.BindExternalSystemAccountIdOpResource)
    case cancelAtomicSwapAskOp(_ resource: Horizon.CancelAtomicSwapAskOpResource)
    case cancelCloseDeferredPaymentRequestOp(_ resource: Horizon.CancelCloseDeferredPaymentRequestOpResource)
    case cancelDataCreationRequestOp(_ resource: Horizon.CancelDataCreationRequestOpResource)
    case cancelDataRemoveRequestOp(_ resource: Horizon.CancelDataRemoveRequestOpResource)
    case cancelDataUpdateRequestOp(_ resource: Horizon.CancelDataUpdateRequestOpResource)
    case cancelDeferredPaymentCreationRequestOp(_ resource: Horizon.CancelDeferredPaymentCreationRequestOpResource)
    case cancelSaleRequestOp(_ resource: Horizon.CancelSaleRequestOpResource)
    case checkSaleStateOp(_ resource: Horizon.CheckSaleStateOpResource)
    case closeSwapOp(_ resource: Horizon.CloseSwapOpResource)
    case createAccountOp(_ resource: Horizon.CreateAccountOpResource)
    case createAmlAlertRequestOp(_ resource: Horizon.CreateAmlAlertRequestOpResource)
    case createAtomicSwapAskRequestOp(_ resource: Horizon.CreateAtomicSwapAskRequestOpResource)
    case createAtomicSwapBidRequestOp(_ resource: Horizon.CreateAtomicSwapBidRequestOpResource)
    case createChangeRoleRequestOp(_ resource: Horizon.CreateChangeRoleRequestOpResource)
    case createCloseDeferredPaymentRequestOp(_ resource: Horizon.CreateCloseDeferredPaymentRequestOpResource)
    case createDataCreationRequestOp(_ resource: Horizon.CreateDataCreationRequestOpResource)
    case createDataOp(_ resource: Horizon.CreateDataOpResource)
    case createDataRemoveRequestOp(_ resource: Horizon.CreateDataRemoveRequestOpResource)
    case createDataUpdateRequestOp(_ resource: Horizon.CreateDataUpdateRequestOpResource)
    case createDeferredPaymentCreationRequestOp(_ resource: Horizon.CreateDeferredPaymentCreationRequestOpResource)
    case createIssuanceRequestOp(_ resource: Horizon.CreateIssuanceRequestOpResource)
    case createKYCRecoveryRequestOp(_ resource: Horizon.CreateKYCRecoveryRequestOpResource)
    case createManageLimitsRequestOp(_ resource: Horizon.CreateManageLimitsRequestOpResource)
    case createManageOfferRequestOp(_ resource: Horizon.CreateManageOfferRequestOpResource)
    case createPaymentRequestOp(_ resource: Horizon.CreatePaymentRequestOpResource)
    case createRedemptionRequestOp(_ resource: Horizon.CreateRedemptionRequestOpResource)
    case createSaleRequestOp(_ resource: Horizon.CreateSaleRequestOpResource)
    case createWithdrawRequestOp(_ resource: Horizon.CreateWithdrawRequestOpResource)
    case initiateKYCRecoveryOp(_ resource: Horizon.InitiateKYCRecoveryOpResource)
    case licenseOp(_ resource: Horizon.LicenseOpResource)
    case lpManageLiquidityOp(_ resource: Horizon.LpManageLiquidityOpResource)
    case lpSwapOp(_ resource: Horizon.LpSwapOpResource)
    case manageAccountRoleOp(_ resource: Horizon.ManageAccountRoleOpResource)
    case manageAccountRuleOp(_ resource: Horizon.ManageAccountRuleOpResource)
    case manageAccountSpecificRuleOp(_ resource: Horizon.ManageAccountSpecificRuleOpResource)
    case manageAssetOp(_ resource: Horizon.ManageAssetOpResource)
    case manageAssetPairOp(_ resource: Horizon.ManageAssetPairOpResource)
    case manageBalanceOp(_ resource: Horizon.ManageBalanceOpResource)
    case manageContractOp(_ resource: Horizon.ManageContractOpResource)
    case manageContractRequestOp(_ resource: Horizon.ManageContractRequestOpResource)
    case manageCreatePollRequestOp(_ resource: Horizon.ManageCreatePollRequestOpResource)
    case manageExternalSystemAccountIDPoolEntryOp(_ resource: Horizon.ManageExternalSystemAccountIDPoolEntryOpResource)
    case manageInvoiceOp(_ resource: Horizon.ManageInvoiceOpResource)
    case manageKeyValueOp(_ resource: Horizon.ManageKeyValueOpResource)
    case manageOfferOp(_ resource: Horizon.ManageOfferOpResource)
    case managePollOp(_ resource: Horizon.ManagePollOpResource)
    case manageSaleOp(_ resource: Horizon.ManageSaleOpResource)
    case manageSignerOp(_ resource: Horizon.ManageSignerOpResource)
    case manageSignerRoleOp(_ resource: Horizon.ManageSignerRoleOpResource)
    case manageSignerRuleOp(_ resource: Horizon.ManageSignerRuleOpResource)
    case manageVoteOp(_ resource: Horizon.ManageVoteOpResource)
    case openSwapOp(_ resource: Horizon.OpenSwapOpResource)
    case paymentOp(_ resource: Horizon.PaymentOpResource)
    case payoutOp(_ resource: Horizon.PayoutOpResource)
    case removeAssetOp(_ resource: Horizon.RemoveAssetOpResource)
    case removeAssetPairOp(_ resource: Horizon.RemoveAssetPairOpResource)
    case removeDataOp(_ resource: Horizon.RemoveDataOpResource)
    case reviewRequestOp(_ resource: Horizon.ReviewRequestOpResource)
    case setFeeOp(_ resource: Horizon.SetFeeOpResource)
    case stampOp(_ resource: Horizon.StampOpResource)
    case updateDataOp(_ resource: Horizon.UpdateDataOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsType: BaseOperationDetailsType {
        if let resource = self as? Horizon.BindExternalSystemAccountIdOpResource {
            return .bindExternalSystemAccountIdOp(resource)
        } else if let resource = self as? Horizon.CancelAtomicSwapAskOpResource {
            return .cancelAtomicSwapAskOp(resource)
        } else if let resource = self as? Horizon.CancelCloseDeferredPaymentRequestOpResource {
            return .cancelCloseDeferredPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CancelDataCreationRequestOpResource {
            return .cancelDataCreationRequestOp(resource)
        } else if let resource = self as? Horizon.CancelDataRemoveRequestOpResource {
            return .cancelDataRemoveRequestOp(resource)
        } else if let resource = self as? Horizon.CancelDataUpdateRequestOpResource {
            return .cancelDataUpdateRequestOp(resource)
        } else if let resource = self as? Horizon.CancelDeferredPaymentCreationRequestOpResource {
            return .cancelDeferredPaymentCreationRequestOp(resource)
        } else if let resource = self as? Horizon.CancelSaleRequestOpResource {
            return .cancelSaleRequestOp(resource)
        } else if let resource = self as? Horizon.CheckSaleStateOpResource {
            return .checkSaleStateOp(resource)
        } else if let resource = self as? Horizon.CloseSwapOpResource {
            return .closeSwapOp(resource)
        } else if let resource = self as? Horizon.CreateAccountOpResource {
            return .createAccountOp(resource)
        } else if let resource = self as? Horizon.CreateAmlAlertRequestOpResource {
            return .createAmlAlertRequestOp(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapAskRequestOpResource {
            return .createAtomicSwapAskRequestOp(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapBidRequestOpResource {
            return .createAtomicSwapBidRequestOp(resource)
        } else if let resource = self as? Horizon.CreateChangeRoleRequestOpResource {
            return .createChangeRoleRequestOp(resource)
        } else if let resource = self as? Horizon.CreateCloseDeferredPaymentRequestOpResource {
            return .createCloseDeferredPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDataCreationRequestOpResource {
            return .createDataCreationRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDataOpResource {
            return .createDataOp(resource)
        } else if let resource = self as? Horizon.CreateDataRemoveRequestOpResource {
            return .createDataRemoveRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDataUpdateRequestOpResource {
            return .createDataUpdateRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDeferredPaymentCreationRequestOpResource {
            return .createDeferredPaymentCreationRequestOp(resource)
        } else if let resource = self as? Horizon.CreateIssuanceRequestOpResource {
            return .createIssuanceRequestOp(resource)
        } else if let resource = self as? Horizon.CreateKYCRecoveryRequestOpResource {
            return .createKYCRecoveryRequestOp(resource)
        } else if let resource = self as? Horizon.CreateManageLimitsRequestOpResource {
            return .createManageLimitsRequestOp(resource)
        } else if let resource = self as? Horizon.CreateManageOfferRequestOpResource {
            return .createManageOfferRequestOp(resource)
        } else if let resource = self as? Horizon.CreatePaymentRequestOpResource {
            return .createPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CreateRedemptionRequestOpResource {
            return .createRedemptionRequestOp(resource)
        } else if let resource = self as? Horizon.CreateSaleRequestOpResource {
            return .createSaleRequestOp(resource)
        } else if let resource = self as? Horizon.CreateWithdrawRequestOpResource {
            return .createWithdrawRequestOp(resource)
        } else if let resource = self as? Horizon.InitiateKYCRecoveryOpResource {
            return .initiateKYCRecoveryOp(resource)
        } else if let resource = self as? Horizon.LicenseOpResource {
            return .licenseOp(resource)
        } else if let resource = self as? Horizon.LpManageLiquidityOpResource {
            return .lpManageLiquidityOp(resource)
        } else if let resource = self as? Horizon.LpSwapOpResource {
            return .lpSwapOp(resource)
        } else if let resource = self as? Horizon.ManageAccountRoleOpResource {
            return .manageAccountRoleOp(resource)
        } else if let resource = self as? Horizon.ManageAccountRuleOpResource {
            return .manageAccountRuleOp(resource)
        } else if let resource = self as? Horizon.ManageAccountSpecificRuleOpResource {
            return .manageAccountSpecificRuleOp(resource)
        } else if let resource = self as? Horizon.ManageAssetOpResource {
            return .manageAssetOp(resource)
        } else if let resource = self as? Horizon.ManageAssetPairOpResource {
            return .manageAssetPairOp(resource)
        } else if let resource = self as? Horizon.ManageBalanceOpResource {
            return .manageBalanceOp(resource)
        } else if let resource = self as? Horizon.ManageContractOpResource {
            return .manageContractOp(resource)
        } else if let resource = self as? Horizon.ManageContractRequestOpResource {
            return .manageContractRequestOp(resource)
        } else if let resource = self as? Horizon.ManageCreatePollRequestOpResource {
            return .manageCreatePollRequestOp(resource)
        } else if let resource = self as? Horizon.ManageExternalSystemAccountIDPoolEntryOpResource {
            return .manageExternalSystemAccountIDPoolEntryOp(resource)
        } else if let resource = self as? Horizon.ManageInvoiceOpResource {
            return .manageInvoiceOp(resource)
        } else if let resource = self as? Horizon.ManageKeyValueOpResource {
            return .manageKeyValueOp(resource)
        } else if let resource = self as? Horizon.ManageOfferOpResource {
            return .manageOfferOp(resource)
        } else if let resource = self as? Horizon.ManagePollOpResource {
            return .managePollOp(resource)
        } else if let resource = self as? Horizon.ManageSaleOpResource {
            return .manageSaleOp(resource)
        } else if let resource = self as? Horizon.ManageSignerOpResource {
            return .manageSignerOp(resource)
        } else if let resource = self as? Horizon.ManageSignerRoleOpResource {
            return .manageSignerRoleOp(resource)
        } else if let resource = self as? Horizon.ManageSignerRuleOpResource {
            return .manageSignerRuleOp(resource)
        } else if let resource = self as? Horizon.ManageVoteOpResource {
            return .manageVoteOp(resource)
        } else if let resource = self as? Horizon.OpenSwapOpResource {
            return .openSwapOp(resource)
        } else if let resource = self as? Horizon.PaymentOpResource {
            return .paymentOp(resource)
        } else if let resource = self as? Horizon.PayoutOpResource {
            return .payoutOp(resource)
        } else if let resource = self as? Horizon.RemoveAssetOpResource {
            return .removeAssetOp(resource)
        } else if let resource = self as? Horizon.RemoveAssetPairOpResource {
            return .removeAssetPairOp(resource)
        } else if let resource = self as? Horizon.RemoveDataOpResource {
            return .removeDataOp(resource)
        } else if let resource = self as? Horizon.ReviewRequestOpResource {
            return .reviewRequestOp(resource)
        } else if let resource = self as? Horizon.SetFeeOpResource {
            return .setFeeOp(resource)
        } else if let resource = self as? Horizon.StampOpResource {
            return .stampOp(resource)
        } else if let resource = self as? Horizon.UpdateDataOpResource {
            return .updateDataOp(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .bindExternalSystemAccountIdOp(let resource):
        
        
    case .cancelAtomicSwapAskOp(let resource):
        
        
    case .cancelCloseDeferredPaymentRequestOp(let resource):
        
        
    case .cancelDataCreationRequestOp(let resource):
        
        
    case .cancelDataRemoveRequestOp(let resource):
        
        
    case .cancelDataUpdateRequestOp(let resource):
        
        
    case .cancelDeferredPaymentCreationRequestOp(let resource):
        
        
    case .cancelSaleRequestOp(let resource):
        
        
    case .checkSaleStateOp(let resource):
        
        
    case .closeSwapOp(let resource):
        
        
    case .createAccountOp(let resource):
        
        
    case .createAmlAlertRequestOp(let resource):
        
        
    case .createAtomicSwapAskRequestOp(let resource):
        
        
    case .createAtomicSwapBidRequestOp(let resource):
        
        
    case .createChangeRoleRequestOp(let resource):
        
        
    case .createCloseDeferredPaymentRequestOp(let resource):
        
        
    case .createDataCreationRequestOp(let resource):
        
        
    case .createDataOp(let resource):
        
        
    case .createDataRemoveRequestOp(let resource):
        
        
    case .createDataUpdateRequestOp(let resource):
        
        
    case .createDeferredPaymentCreationRequestOp(let resource):
        
        
    case .createIssuanceRequestOp(let resource):
        
        
    case .createKYCRecoveryRequestOp(let resource):
        
        
    case .createManageLimitsRequestOp(let resource):
        
        
    case .createManageOfferRequestOp(let resource):
        
        
    case .createPaymentRequestOp(let resource):
        
        
    case .createRedemptionRequestOp(let resource):
        
        
    case .createSaleRequestOp(let resource):
        
        
    case .createWithdrawRequestOp(let resource):
        
        
    case .initiateKYCRecoveryOp(let resource):
        
        
    case .licenseOp(let resource):
        
        
    case .lpManageLiquidityOp(let resource):
        
        
    case .lpSwapOp(let resource):
        
        
    case .manageAccountRoleOp(let resource):
        
        
    case .manageAccountRuleOp(let resource):
        
        
    case .manageAccountSpecificRuleOp(let resource):
        
        
    case .manageAssetOp(let resource):
        
        
    case .manageAssetPairOp(let resource):
        
        
    case .manageBalanceOp(let resource):
        
        
    case .manageContractOp(let resource):
        
        
    case .manageContractRequestOp(let resource):
        
        
    case .manageCreatePollRequestOp(let resource):
        
        
    case .manageExternalSystemAccountIDPoolEntryOp(let resource):
        
        
    case .manageInvoiceOp(let resource):
        
        
    case .manageKeyValueOp(let resource):
        
        
    case .manageOfferOp(let resource):
        
        
    case .managePollOp(let resource):
        
        
    case .manageSaleOp(let resource):
        
        
    case .manageSignerOp(let resource):
        
        
    case .manageSignerRoleOp(let resource):
        
        
    case .manageSignerRuleOp(let resource):
        
        
    case .manageVoteOp(let resource):
        
        
    case .openSwapOp(let resource):
        
        
    case .paymentOp(let resource):
        
        
    case .payoutOp(let resource):
        
        
    case .removeAssetOp(let resource):
        
        
    case .removeAssetPairOp(let resource):
        
        
    case .removeDataOp(let resource):
        
        
    case .reviewRequestOp(let resource):
        
        
    case .setFeeOp(let resource):
        
        
    case .stampOp(let resource):
        
        
    case .updateDataOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/

// Auto-generated code. Do not edit.

import Foundation

public enum ManageSignerOpType {
    
    case operationsCreateSigner(_ resource: Horizon.OperationsCreateSignerResource)
    case operationsRemoveSigner(_ resource: Horizon.OperationsRemoveSignerResource)
    case operationsUpdateSigner(_ resource: Horizon.OperationsUpdateSignerResource)
    case `self`(_ resource: Horizon.ManageSignerOpResource)
}

extension Horizon.ManageSignerOpResource {
    
    public var manageSignerOpType: ManageSignerOpType {
        if let resource = self as? Horizon.OperationsCreateSignerResource {
            return .operationsCreateSigner(resource)
        } else if let resource = self as? Horizon.OperationsRemoveSignerResource {
            return .operationsRemoveSigner(resource)
        } else if let resource = self as? Horizon.OperationsUpdateSignerResource {
            return .operationsUpdateSigner(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .operationsCreateSigner(let resource):
        
        
    case .operationsRemoveSigner(let resource):
        
        
    case .operationsUpdateSigner(let resource):
        
        
    case .`self`(let resource):
        
    }
*/

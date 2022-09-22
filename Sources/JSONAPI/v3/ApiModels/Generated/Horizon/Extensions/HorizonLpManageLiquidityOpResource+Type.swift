// Auto-generated code. Do not edit.

import Foundation

public enum LpManageLiquidityOpType {
    
    case operationsLpAddLiquidity(_ resource: Horizon.OperationsLpAddLiquidityResource)
    case operationsLpRemoveLiquidity(_ resource: Horizon.OperationsLpRemoveLiquidityResource)
    case `self`(_ resource: Horizon.LpManageLiquidityOpResource)
}

extension Horizon.LpManageLiquidityOpResource {
    
    public var lpManageLiquidityOpType: LpManageLiquidityOpType {
        if let resource = self as? Horizon.OperationsLpAddLiquidityResource {
            return .operationsLpAddLiquidity(resource)
        } else if let resource = self as? Horizon.OperationsLpRemoveLiquidityResource {
            return .operationsLpRemoveLiquidity(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .operationsLpAddLiquidity(let resource):
        
        
    case .operationsLpRemoveLiquidity(let resource):
        
        
    case .`self`(let resource):
        
    }
*/

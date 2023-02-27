import Foundation

/// Possible Ids for key value entries.
public enum KeyValueEntries {
    
    public static let accountRoleBlocked: String = "account_role:blocked"
    public static let accountRoleCorporate: String = "account_role:corporate"
    public static let accountRoleGeneral: String = "account_role:general"
    public static let accountRoleUnverified: String = "account_role:unverified"
    public static let assetCreateTasks: String = "asset_create_tasks"
    public static let assetTypeKycRequired: String = "asset_type:kyc_required"
    public static let assetUpdateTasks: String = "asset_update_tasks"
    public static let assetUpdateTasksAst: String = "asset_update_tasks:*"
    public static let changeRoleTasks: String = "change_role_tasks:*:*"
    public static let issuanceTasks: String = "issuance_tasks:*"
    public static let limitsUpdateTasks: String = "limits_update_tasks"
    public static let preissuanceTasks: String = "preissuance_tasks:*"
    public static let saleCreateTasks: String = "sale_create_tasks:*"
    public static let signerRoleDefault: String = "signer_role:default"
    public static let withdrawalTasks: String = "withdrawal_tasks:*"
    public static let fiatAssets: String = "fiat_assets"
}

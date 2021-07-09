import Foundation

public extension Contoparty {
    
    enum TokensHistoryRequestFilterOptionV3: FilterOption {
        
        case token_id(_ value: Int)
        case created_at(_ value: String)
        case op_type(_ value: String)
        case asset_code(_ value: String)
    }
    
    class TokensHistoryRequestFiltersV3: RequestFilters<TokensHistoryRequestFilterOptionV3> {}
}

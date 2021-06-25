import Foundation

public extension Contoparty {
    
    enum TokensRequestFilterOptionV3: FilterOption {
        
        case owner(_ value: String)
        case asset_code(_ value: String)
        case status(_ value: Int)
        case edition(_ value: String)
        case id(_ value: [Int64])
    }
    
    class TokensRequestFiltersV3: RequestFilters<TokensRequestFilterOptionV3> {}
}

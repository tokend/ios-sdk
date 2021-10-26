import Foundation

public extension Contoparty {
    
    enum TokensHistoryRequestFilterOptionV3: FilterOption {
        
        case tokenId(_ value: Int)
        case createdAt(_ value: String)
        case opType(_ value: String)
        case assetCode(_ value: String)
    }
    
    class TokensHistoryRequestFiltersV3: RequestFilters<TokensHistoryRequestFilterOptionV3> {}
}

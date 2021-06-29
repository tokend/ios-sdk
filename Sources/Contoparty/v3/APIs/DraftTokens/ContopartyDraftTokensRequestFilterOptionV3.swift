import Foundation

public extension Contoparty {
    
    enum DraftTokensRequestFilterOptionV3: FilterOption {
        
        case creator(_ value: String)
        case id(_ value: [Int64])
    }
    
    class DraftTokensRequestFiltersV3: RequestFilters<DraftTokensRequestFilterOptionV3> {}
}

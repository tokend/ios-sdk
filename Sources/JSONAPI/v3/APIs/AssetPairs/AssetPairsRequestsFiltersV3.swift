import Foundation

public enum AssetPairsRequestsFilterOptionV3: FilterOption {
    
    case baseAsset(String)
    case quoteAsset(String)
    case asset(String)
    
    /// Other filters.
    case other(_ value: [String: String])
}

public class AssetPairsRequestsFiltersV3: RequestFilters<AssetPairsRequestsFilterOptionV3> {}

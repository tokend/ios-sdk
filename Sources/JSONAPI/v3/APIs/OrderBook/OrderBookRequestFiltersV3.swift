import Foundation

public enum OrderBookRequestFilterOptionV3: FilterOption {
    
    case baseAsset(_ value: String)       // Base asset of the requested offers.
    case quoteAsset(_ value: String)      // Quote asset the requested offers.
    case isBuy(_ value: Bool)             // Searching of offer on buying base_asset, selling it, or both.
    case other(_ value: [String: String]) // Other filters.
}

public class OrderBookRequestFiltersV3: RequestFilters<OrderBookRequestFilterOptionV3> {}

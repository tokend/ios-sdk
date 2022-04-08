import Foundation

public enum OffersRequestFilterOptionV3: FilterOption {
    
    case owner(_ value: String)
    case baseBalance(_ balanceId: String)
    case quoteBalance(_ balanceId: String)
    case baseAsset(_ value: String)
    case qouteAsset(_ value: String)
    case orderBook(_ value: Int64)
    case isBuy(_ value: Int32)
}

public class OffersRequestFilterV3: RequestFilters <OffersRequestFilterOptionV3> {}

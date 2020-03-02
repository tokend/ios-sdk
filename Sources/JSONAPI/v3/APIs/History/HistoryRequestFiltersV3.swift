import Foundation

public enum HistoryRequestFilterOptionV3: FilterOption {
    
    case account(_ accountId: String)     // If present, the result will return only effects for specified account.
    case balance(_ balanceId: String)     // If present, the result will return only effects for specified balance.
    case other(_ value: [String: String]) // Other filters.
}

public class HistoryRequestFiltersV3: RequestFilters<HistoryRequestFilterOptionV3> {}

public typealias MovementsRequestFilterV3 = HistoryRequestFiltersV3

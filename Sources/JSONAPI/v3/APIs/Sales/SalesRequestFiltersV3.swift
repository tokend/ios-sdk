import Foundation

public enum SalesRequestFilterOptionV3: FilterOption {
    
    case baseAsset(_ value: String)       // Base asset of the sale.
    case maxEndTime(_ value: Date)        // Maximum end time of the sale. RFC3339 formatted time.
    case maxHardCap(_ value: Decimal)     // Maximum hard cap of the sale.
    case maxSoftCap(_ value: Decimal)     // Maximum soft cap of the sale.
    case maxStartTime(_ value: Date)      // Maximum start time of the sale. RFC3339 formatted time.
    case minEndTime(_ value: Date)        // Minimum end time of the sale. RFC3339 formatted time.
    case minHardCap(_ value: Decimal)     // Minimum hard cap of the sale.
    case minSoftCap(_ value: Decimal)     // Minimum soft cap of the sale.
    case minStartTime(_ value: Date)      // Minimum start time of the sale. RFC3339 formatted time.
    case owner(_ value: String)           // AccountId of sale's owner.
    case saleType(_ value: Decimal)       // Type of the sale.
    case state(_ value: Int)              // State of the sale.
    case other(_ value: [String: String]) // Other filters.
}

public class SalesRequestFiltersV3: RequestFilters <SalesRequestFilterOptionV3> {}

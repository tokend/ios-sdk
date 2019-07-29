import Foundation

public enum AtomicSwapRequestFilterOptionV3: FilterOption {
    
    case baseAsset(_ asset: String)     // If present, the result will return only asks for specified base asset.
    case owner(_ owner: String)     // If present, the result will return only asks for specified owner.
}

public class AtomicSwapFiltersV3: RequestFilters<AtomicSwapRequestFilterOptionV3> {}

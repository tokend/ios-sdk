import Foundation

public enum LiquidityPoolsFilterOptionV3: FilterOption {
    case asset(_ value: String)
    case lpToken(_ value: String)
    case balancesOwner(_ value: String)
    case excludedAssets(_ value: [String])
}

public class LiquidityPoolsFiltersV3: RequestFilters <LiquidityPoolsFilterOptionV3> {}

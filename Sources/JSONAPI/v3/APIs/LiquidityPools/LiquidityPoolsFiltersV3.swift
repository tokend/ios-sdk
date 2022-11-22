import Foundation

public enum LiquidityPoolsFilterOptionV3: FilterOption {
    case asset(_ value: String)
    case lpToken(_ value: String)
}

public class LiquidityPoolsFiltersV3: RequestFilters <LiquidityPoolsFilterOptionV3> {}

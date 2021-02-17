import Foundation

public enum VaccineResultsRequestFilterOptionV3: FilterOption {
    
    case creator(_ value: String)
    case participant(_ value: String)
}

public class VaccineResultsRequestFiltersV3: RequestFilters<VaccineResultsRequestFilterOptionV3> {}

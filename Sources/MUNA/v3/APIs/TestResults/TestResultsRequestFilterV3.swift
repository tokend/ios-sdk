import Foundation

public enum TestResultsRequestFilterOptionV3: FilterOption {
    
    case creator(_ value: String)
    case participant(_ value: String)
}

public class TestResultsRequestFiltersV3: RequestFilters<TestResultsRequestFilterOptionV3> {}

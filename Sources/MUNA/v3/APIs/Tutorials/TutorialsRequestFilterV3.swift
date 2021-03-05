import Foundation

public enum TutorialsRequestFilterOptionV3: FilterOption {
    
    case category(_ value: String)
}

public class TutorialsRequestFiltersV3: RequestFilters<TutorialsRequestFilterOptionV3> {}

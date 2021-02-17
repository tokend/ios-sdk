import Foundation

public enum SchedulerRequestFilterOptionV3: FilterOption {
    
    case payload(_ value: String)
    case other(_ value: [String: String])
}

public class SchedulerRequestFiltersV3: RequestFilters<SchedulerRequestFilterOptionV3> {}

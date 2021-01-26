import Foundation

public enum SchedulerRequestFilterOptionV3: FilterOption {
    
    case payload(_ value: String)
    case startTime(_ value: Int)
    case endTime(_ value: Int)
}

public class SchedulerRequestFiltersV3: RequestFilters<SchedulerRequestFilterOptionV3> {}

// Other filters.
//case other(_ value: [String: String])

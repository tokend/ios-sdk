import Foundation

public enum EventHistoryRequestFilterOptionV3: FilterOption {
    
    case owner(_ value: String)
}

public class EventHistoryRequestFiltersV3: RequestFilters<BookingRequestFilterOptionV3> {}

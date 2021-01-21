import Foundation

public enum BookingRequestFilterOptionV3: FilterOption {
    
    case owner(_ value: String)
}

public class BookingRequestFiltersV3: RequestFilters<BookingRequestFilterOptionV3> {}

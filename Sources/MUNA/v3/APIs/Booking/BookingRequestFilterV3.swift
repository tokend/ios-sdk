import Foundation

public enum BookingRequestFilterOptionV3: FilterOption {
    
    case owner(_ value: String)
    case state(_ value: Int)
    case type(_ value: Int)
}

public class BookingRequestFiltersV3: RequestFilters<BookingRequestFilterOptionV3> {}

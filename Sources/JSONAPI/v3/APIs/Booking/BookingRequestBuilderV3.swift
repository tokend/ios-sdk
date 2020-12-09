import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch booking data
public class BookingRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    private var integrations: String { "integrations" }
    private var booking: String { "booking" }
    private var businesses: String { "businesses" }
    
    
    public func buildListBusinessesRequest(
        filters: BookingRequestFiltersV3
    ) {
        
    }
}

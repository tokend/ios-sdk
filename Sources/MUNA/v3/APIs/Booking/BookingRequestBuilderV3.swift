import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch booking data
public class BookingRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    private var integrations: String { "integrations" }
    private var booking: String { "booking" }
    private var bookings: String { "bookings" }
    private var businesses: String { "businesses" }
    
    /// Builds request to get bookings list
    public func buildListBookingsRequest(
        filters: BookingRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.integrations/self.booking
        
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            .simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to get booking
    /// - Parameters:
    ///   - bookingId: The booking id.
    public func buildBookingByIdRequest(
        bookingId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.integrations/self.booking/bookingId
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to get businesses list
    public func buildListBusinessesRequest(
        filters: BookingRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.integrations/self.booking/self.businesses
        
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            .simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to get business
    /// - Parameters:
    ///   - businessId: The business id.
    public func buildBusinessByIdRequest(
        businessId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.integrations/self.booking/self.businesses/businessId
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to book new event for business
    /// - Parameters:
    ///   - businessId: The business id.
    public func buildBookEventRequest(
        businessId: String,
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.integrations/self.booking/self.businesses/businessId/self.bookings
        
        self.buildRequest(
            .simpleBody(
                path: path,
                method: .post,
                bodyParameters: bodyParameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    public func buildCancelBookingRequest(
        businessId: String,
        bookingId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = /self.integrations/self.booking/self.businesses/businessId/self.bookings
        
        self.buildRequest(
            .init(
                path: path,
                method: .delete
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

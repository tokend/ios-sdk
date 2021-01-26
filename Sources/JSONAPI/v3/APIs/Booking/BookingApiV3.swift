import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch bookings' data
public class BookingApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties

    public let requestBuilder: BookingRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = BookingRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to fetch list of bookings from api.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestCollectionResult<BookingResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getListBookings(
        filters: BookingRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<MunaBooking.BookingResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildListBookingsRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    MunaBooking.BookingResource.self,
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .success(let document):
                            completion(.success(document))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
    
    /// Method sends request to fetch booking's data from api.
    /// - Parameters:
    ///   - bookingId: Identifier of booking for which data will be fetched.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestSingleResult<BookingResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getBookingById(
        bookingId: String,
        completion: @escaping (_ result: RequestSingleResult<MunaBooking.BookingResource>) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildBookingByIdRequest(
            bookingId: bookingId,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    MunaBooking.BookingResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                        
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
    
    /// Method sends request to fetch list of businesses from api.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestCollectionResult<BusinessResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getListBusinesses(
        filters: BookingRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<MunaBooking.BusinessResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildListBusinessesRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    MunaBooking.BusinessResource.self,
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .success(let document):
                            completion(.success(document))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
    
    /// Method sends request to fetch business's data from api.
    /// - Parameters:
    ///   - businessId: Identifier of business for which data will be fetched.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestSingleResult<BusinessResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getBusinessById(
        businessId: String,
        completion: @escaping (_ result: RequestSingleResult<MunaBooking.BusinessResource>) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildBusinessByIdRequest(
            businessId: businessId,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    MunaBooking.BusinessResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                        
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
}

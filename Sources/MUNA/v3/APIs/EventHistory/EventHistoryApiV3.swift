import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch events history' data

public class EventHistoryApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties

    public let requestBuilder: EventHistoryRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = EventHistoryRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public

    /// Method sends request to fetch list of events from api.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestCollectionResult<Horizon.DataResource>`
    /// - Returns: `Cancelable`
    
    @discardableResult
    public func getEventHistory(
        filters: EventHistoryRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<Horizon.DataResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildEventHistoryRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    Horizon.DataResource.self,
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
}

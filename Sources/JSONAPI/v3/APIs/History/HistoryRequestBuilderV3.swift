import Foundation

/// Class provides functionality that allows to build history requests
public class HistoryRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let history = "history"
    public let movements = "movements"
    
    // MARK: - Public
    
    /// Builds request to fetch history data from api
    public func buildHistoryRequest(
        filters: HistoryRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = self.v3/self.history
        
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryIncludePagination(
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
    
    /// Builds request to fetch movements data from api
    public func buildMovementsRequest(
        filters: MovementsRequestFilterV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = self.v3/self.movements
        
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryIncludePagination(
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
}

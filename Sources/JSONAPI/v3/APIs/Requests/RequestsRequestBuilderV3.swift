import Foundation

/// Class provides functionality that allows to build reviewable request requests
public class RequestsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    private let requests: String = "requests"
    
    // MARK: - Public
    
    /// Builds request to fetch reviewable requests data from api
    public func buildRequestsRequest(
        filters: RequestsFiltersV3?,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = self.v3/self.requests
        
        let queryParameters: RequestQueryParameters
        if let filters = filters {
            queryParameters = self.buildFilterQueryItems(filters.filterItems)
        } else {
            queryParameters = [:]
        }
        
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

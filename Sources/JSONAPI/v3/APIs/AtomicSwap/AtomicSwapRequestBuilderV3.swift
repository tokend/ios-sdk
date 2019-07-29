import Foundation

/// Class provides functionality that allows to build atomic swap asks requests
public class AtomicSwapRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    private let asksPath: String = "atomic_swap_asks"
    
    // MARK: - Public
    
    /// Builds request to fetch atomic swap asks data from api
    public func buildAtomicSwapAsksRequest(
        filters: AtomicSwapFiltersV3?,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.asksPath
        
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

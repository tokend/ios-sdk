import Foundation

public extension Contoparty {
    
    class TokensRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
        
        // MARK: - Private properties
        
        private var tokens: String { "tokens" }
        private var history: String { "history" }
    }
}

// MARK: - Public methods

public extension Contoparty.TokensRequestBuilderV3 {
    
    func buildGetListOfProjects(
        filters: Contoparty.TokensRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.tokens
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
}

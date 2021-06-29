import Foundation

public extension Contoparty {
    
    class DraftTokensRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
        
        // MARK: - Private properties
        
        private var tokens: String { "tokens" }
        private var draft: String { "draft" }
    }
}

// MARK: - Public methods

public extension Contoparty.DraftTokensRequestBuilderV3 {
    
    func buildGetListOfDraftTokens(
        filters: Contoparty.DraftTokensRequestFiltersV3,
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


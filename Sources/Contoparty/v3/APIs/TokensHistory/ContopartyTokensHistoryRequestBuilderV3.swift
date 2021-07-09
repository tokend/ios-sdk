import Foundation

public extension Contoparty {
    
    class TokensHistoryRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
        
        // MARK: - Private properties
        
        private var tokens: String { "tokens" }
        private var history: String { "history" }
    }
}

// MARK: - Public methods

public extension Contoparty.TokensHistoryRequestBuilderV3 {
    
    func buildTokensHistoryRequest(
        filters: Contoparty.TokensHistoryRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = self.tokens/self.history
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

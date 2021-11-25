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
        
        let path = self.tokens/self.draft
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
    
    func buildGetDraftTokenById(
        id: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.tokens/self.draft/id

        self.buildRequest(
            .simple(
                path: path,
                method: .get
            ),
            shouldSign: false,
            sendDate: sendDate,
            completion: completion
        )

    }
    
    func buildUpdateTokenDetails(
        id: String,
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.tokens/self.draft/id
        
        self.buildRequest(
            .simpleBody(
                path: path,
                method: .put,
                bodyParameters: bodyParameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    func buildDeleteDraftTokenRequest(
        id: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = self.tokens/self.draft/id

        self.buildRequest(
            .simple(
                path: path,
                method: .delete
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    func buildCreateDraftTokenRequest(
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = self.tokens/self.draft
        
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
}

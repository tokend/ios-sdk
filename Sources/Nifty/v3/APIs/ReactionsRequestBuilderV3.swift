import Foundation

public class ReactionsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    private let integrations: String = "integrations"
    public let likes = "likes"
    public let reactions = "reactions"
    public let sales = "sales"
    
    // MARK: - Public
    
    public func buildCreateReactionRequest(
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = /self.integrations/self.likes

        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleBody(
                path: path,
                method: .post,
                bodyParameters: bodyParameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    public func buildDeleteReactionRequest(
        titleId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.likes/self.reactions/titleId

        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .delete
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    public func buildGetReactionsListRequest(
        filters: ReactionsRequestFiltersV3,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.likes/self.reactions
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)

        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQuery(
                path: path,
                method: .get,
                queryParameters: queryParameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    public func buildGetTitlesListRequest(
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.likes/self.sales

        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simplePagination(
                path: path,
                method: .get,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

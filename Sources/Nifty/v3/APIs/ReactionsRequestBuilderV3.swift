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
        
        let path = self.integrations/self.likes/self.reactions

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

        let path = self.integrations/self.likes/self.reactions/titleId

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
        include: [String]?,
        filters: ReactionsRequestFiltersV3,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = self.integrations/self.likes/self.reactions
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)

        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryInclude(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                include: include
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    public func buildGetSalesListRequest(
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = self.integrations/self.likes/self.sales

        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: RequestQueryParameters(),
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch account data
public class AccountsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    private let accounts: String = "accounts"
    private let signers: String = "signers"
    private let changeRoleRequests: String = "change_role_requests"
    private let requests: String = "requests"
    private let convertedBalances: String = "converted_balances"
    
    // MARK: - Public
    
    /// Builds request to fetch account data from api
    /// - Parameters:
    ///   - accountId: Identifier of account to be fetched.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildAccountRequest(
        accountId: String,
        include: [String]?,
        pagination: RequestPagination?,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.accounts/accountId
        
        let pagination = pagination ?? RequestPagination(
            .indexedSingle(index: 0, limit: 1, order: .ascending)
        )
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: [:],
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to fetch signers for exact account
    /// - Parameters:
    ///   - accountId: Identifier of account for which signers to be fetched.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildSignersRequest(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.accounts/accountId/self.signers
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to fetch change role requests
    public func buildChangeRoleRequestsRequest(
        filters: ChangeRoleRequestsFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.changeRoleRequests
        
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
    
    /// Builds request to fetch reviewable request
    public func buildRequestRequest(
        accountId: String,
        requestId: String,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.accounts/accountId/self.requests/requestId
        
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
    
    /// Builds request to fetch converted balances
    public func buildConvertedBalancesRequest(
        accountId: String,
        convertationAsset: String,
        include: [String]?,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.accounts/accountId/self.convertedBalances/convertationAsset
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryInclude(
                path: path,
                method: .get,
                queryParameters: [:],
                include: include
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

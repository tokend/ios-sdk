import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch liquidity pools' data
public class LiquidityPoolsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let liquidityPools = "liquidity-pools"
    
    // MARK: - Public
    
    /// Builds request to fetch liquidity pool by id.
    /// - Parameters:
    ///   - liquidityPoolId: Id of liquidityPool to be fetched.
    /// - Returns: `RequestModel`.
    public func buildGetLiquidityPoolByIdRequest(
        liquidityPoolId: String
    ) -> JSONAPI.RequestModel {
        
        let path = self.v3/self.liquidityPools/liquidityPoolId
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            )
        )
    }
    
    /// Builds request to fetch sales.
    /// - Parameters:
    ///   - parameters: Liquidity pools request parameters.
    ///   - other: Extra request parameters.
    ///   - pagination: Pagination option.
    /// - Returns: `RequestModel`.
    public func buildGetLiquidityPoolsRequest(
        filters: LiquidityPoolsFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.v3/self.liquidityPools
        
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

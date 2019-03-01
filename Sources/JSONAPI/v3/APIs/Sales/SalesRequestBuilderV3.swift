import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch sales' data
public class SalesRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let sales = "sales"
    
    // MARK: - Public
    
    /// Builds request to fetch sale by id.
    /// - Parameters:
    ///   - saleId: Id of sale to be fetched.
    /// - Returns: `RequestModel`.
    public func buildGetSalesRequest(
        saleId: String
        ) -> JSONAPI.RequestModel {
        
        let path = /self.v3/self.sales/saleId
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            )
        )
    }
    
    /// Builds request to fetch sales.
    /// - Parameters:
    ///   - parameters: Sales request parameters.
    ///   - other: Extra request parameters.
    ///   - pagination: Pagination option.
    /// - Returns: `RequestModel`.
    public func buildGetSalesRequest(
        filters: SalesRequestFiltersV3,
        pagination: RequestPagination
        ) -> JSONAPI.RequestModel {
        
        let path = /self.v3/self.sales
        
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryPagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                pagination: pagination
            )
        )
    }
}

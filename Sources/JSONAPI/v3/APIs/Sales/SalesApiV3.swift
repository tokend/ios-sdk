import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch sales' data
public class SalesApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: SalesRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = SalesRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to fetch sale by id.
    /// - Parameters:
    ///   - saleId: Id of sale to be fetched.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestSingleResult<SaleResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getSale(
        saleId: String,
        completion: @escaping ((_ result: RequestSingleResult<Horizon.SaleResource>) -> Void)
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildGetSalesRequest(
            saleId: saleId
        )
        
        return self.requestSingle(
            Horizon.SaleResource.self,
            request: request,
            completion: completion
        )
    }
    
    /// Method sends request to fetch sales from api
    /// - Parameters:
    ///   - parameters: Sales request parameters.
    ///   - other: Extra request parameters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestCollectionResult<SaleResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getSales(
        filters: SalesRequestFiltersV3,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping ((_ result: RequestCollectionResult<Horizon.SaleResource>) -> Void)
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildGetSalesRequest(
            filters: filters,
            pagination: pagination
        )
        
        onRequestBuilt?(request)
        
        return self.requestCollection(
            Horizon.SaleResource.self,
            request: request,
            completion: completion
        )
    }
}

import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch liquidity pools' data
public class LiquidityPoolsApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: LiquidityPoolsRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = LiquidityPoolsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to fetch liquidity pool by id.
    /// - Parameters:
    ///   - saleId: Id of liquidity pool to be fetched.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestSingleResult<LiquidityPoolResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getLiquidityPool(
        liquidityPoolId: String,
        completion: @escaping ((_ result: RequestSingleResult<Horizon.LiquidityPoolResource>) -> Void)
    ) -> Cancelable {
        
        let request = self.requestBuilder.buildGetLiquidityPoolByIdRequest(
            liquidityPoolId: liquidityPoolId
        )
        
        return self.requestSingle(
            Horizon.LiquidityPoolResource.self,
            request: request,
            completion: completion
        )
    }
    
    /// Method sends request to fetch liquidity pools from api
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<LiquidityPoolResource>`.
    /// - Returns: `Cancelable`
    @discardableResult
    public func getLiquidityPools(
        filters: LiquidityPoolsFiltersV3,
        include: [String]? = nil,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping ((_ result: RequestCollectionResult<Horizon.LiquidityPoolResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetLiquidityPoolsRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                onRequestBuilt?(request)
                
                cancelable.cancelable = self?.requestCollection(
                    Horizon.LiquidityPoolResource.self,
                    request: request,
                    completion: completion
                )
            }
        )
        return cancelable
    }
}

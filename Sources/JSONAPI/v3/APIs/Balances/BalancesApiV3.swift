import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch balances
public class BalancesApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: BalancesRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = BalancesRequestBuilderV3(
            builderStack: JSONAPI.BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to get balances api.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - accountId: If present, the result will contain only balances owned by specified account.
    ///   - asset: If present, the result will contain only balances of specified asset.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///     - result: Member of `RequestCollectionResult<BalanceResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestDetails(
        accountId: String?,
        asset: String?,
        pagination: RequestPagination,
        completion: @escaping (_ result: RequestCollectionResult<Horizon.BalanceResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildDetailsRequest(
            accountId: accountId,
            asset: asset,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    Horizon.BalanceResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
    
    /// Method sends request to get balance by id.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - balanceId: The id of the requested balance.
    ///   - completion: Block that will be called when the result will be received.
    ///     - result: Member of `RequestSingleResult<BalanceResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestDetails(
        balanceId: String,
        completion: @escaping (_ result: RequestSingleResult<Horizon.BalanceResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildDetailsRequest(
            balanceId: balanceId,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    Horizon.BalanceResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
}

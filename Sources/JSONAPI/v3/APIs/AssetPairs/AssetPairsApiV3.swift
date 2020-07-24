import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch asset pairs
public class AssetPairsApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: AssetPairsRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = AssetPairsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to get asset pairs for according account from api.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<AssetPairResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAssetPairs(
        filters: AssetPairsRequestsFiltersV3,
        include: [String]? = nil,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping (_ result: RequestCollectionResult<Horizon.AssetPairResource>) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildAssetPairsRequest(
            filters: filters,
            include: include,
            pagination: pagination
        )
        
        onRequestBuilt?(request)
        
        let cancelable = self.requestCollection(
            Horizon.AssetPairResource.self,
            request: request,
            completion: completion
        )
        
        return cancelable
    }
    
    /// Method sends request to get asset pairs for according base and quote assets.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - baseAsset: Base asset in pair
    ///   - quoteAsset: Quote asset in pair
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<AssetPairResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAssetPair(
        baseAsset: String,
        qupteAsset: String,
        completion: @escaping (_ result: RequestSingleResult<Horizon.AssetPairResource>) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildAssetPairRequest(
            baseAsset: baseAsset,
            quoteAsset: qupteAsset
        )
        
        let cancelable = self.requestSingle(
            Horizon.AssetPairResource.self,
            request: request,
            completion: completion
        )
        
        return cancelable
    }
}

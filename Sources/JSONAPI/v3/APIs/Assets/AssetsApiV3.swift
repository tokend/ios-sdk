import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch assets
public class AssetsApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: AssetsRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = AssetsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to get assets for according account from api.
    /// The result of request will be fetched in `completion` block as `AssetsApiV3.RequestAssetsResult`
    /// - Parameters:
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<AssetResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAssets(
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping (_ result: RequestCollectionResult<AssetResource>) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildAssetsRequest(pagination: pagination)
        
        onRequestBuilt?(request)
        
        let cancelable = self.requestCollection(
            AssetResource.self,
            request: request,
            completion: completion
        )
        
        return cancelable
    }
    
    /// Method sends request to get asset of specific identifier from api.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - assetId: Id of asset to be fetched.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<AssetResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAssetById(
        assetId: String,
        completion: @escaping (_ result: RequestSingleResult<AssetResource>) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildAssetByIdRequest(assetId: assetId)
        
        let cancelable = self.requestSingle(
            AssetResource.self,
            request: request,
            completion: completion
        )
        
        return cancelable
    }
}

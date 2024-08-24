import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch assets
public class AssetsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let assets = "assets"
    
    // MARK: - Public
    
    /// Builds request to fetch assets from api
    /// - Parameters:
    ///   - pagination: Pagination option.
    /// - Returns: `RequestModel`.
    public func buildAssetsRequest(
        pagination: RequestPagination
        ) -> JSONAPI.RequestModel {
        
        let path = self.v3/self.assets
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simplePagination(
                path: path,
                method: .get,
                pagination: pagination
            )
        )
    }
    
    /// Builds request to fetch asset by id from api
    /// - Parameters:
    ///   - assetId: Id of asset to be fetched.
    /// - Returns: `RequestModel`.
    public func buildAssetByIdRequest(
        assetId: String
        ) -> JSONAPI.RequestModel {
        
        let path = self.v3/self.assets/assetId
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            )
        )
    }
}

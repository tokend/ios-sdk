import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch asset pairs
public class AssetPairsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch asset pairs from api
    /// - Parameters:
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `AssetPairsRequest` or nil.
    public func buildAssetPairsRequest(
        sendDate: Date,
        completion: @escaping (AssetPairsRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("asset_pairs")
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
}

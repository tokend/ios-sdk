import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch asset pairs
public class AssetPairsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch asset pairs from api
    /// - Parameters:
    ///   - sendDate: Send time of request.
    /// - Returns: `AssetPairsRequest`
    public func buildAssetPairsRequest(sendDate: Date) -> AssetPairsRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("asset_pairs")
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = AssetPairsRequest(
            url: url,
            method: .get,
            signedHeaders: signedHeaders
        )
        
        return request
    }
}

import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch assets
public class AssetsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch assets from api
    /// - Parameters:
    ///   - sendDate: Send time of request.
    /// - Returns: `AssetsRequest`
    public func buildAssetsRequest(sendDate: Date) -> AssetsRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("assets")
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = AssetsRequest(
            url: url,
            method: .get,
            signedHeaders: signedHeaders
        )
        
        return request
    }
}

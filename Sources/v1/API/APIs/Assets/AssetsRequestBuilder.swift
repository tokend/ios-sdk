import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch assets
public class AssetsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch assets from api
    /// - Parameters:
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `AssetsRequest` or nil.
    public func buildAssetsRequest(
        sendDate: Date,
        completion: @escaping (AssetsRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("assets")
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
}

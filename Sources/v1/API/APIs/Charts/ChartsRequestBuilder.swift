import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch charts
public class ChartsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch charts for according asset from api
    /// - Parameters:
    ///   - asset: The code of the asset for which charts are going to be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `ChartsRequest` or nil.
    public func buildChartsRequest(
        asset: String,
        sendDate: Date,
        completion: @escaping (ChartsRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("charts").addPath(asset)
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
}

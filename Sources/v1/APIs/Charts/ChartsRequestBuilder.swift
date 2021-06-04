import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch charts
public class ChartsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Private properties
    
    private let charts: String = "charts"
    
}
    
// MARK: - Public methods

public extension ChartsRequestBuilder {
    
    /// Builds request to fetch charts for according asset from api
    /// - Parameters:
    ///   - asset: The code of the asset for which charts are going to be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `ChartsRequest` or nil.
    func buildChartsRequest(
        asset: String,
        sendDate: Date,
        completion: @escaping (RequestSigned?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.charts/asset
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
}

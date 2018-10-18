import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch charts
public class ChartsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch charts for according asset from api
    /// - Parameters:
    ///   - asset: The code of the asset for which charts are going to be fetched.
    ///   - sendDate: Send time of request.
    /// - Returns: `ChartsRequest`
    public func buildChartsRequest(
        asset: String,
        sendDate: Date
        ) -> ChartsRequest {
        
        let url = self.apiConfiguration.urlString.addPath("charts").addPath(asset)
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(
            request: requestSignModel,
            sendDate: sendDate
        )
        
        let request = ChartsRequest(
            url: url,
            method: .get,
            signedHeaders: signedHeaders
        )
        
        return request
    }
}

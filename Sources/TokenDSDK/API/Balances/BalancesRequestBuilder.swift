import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch balances
public class BalancesRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch balances from api
    /// - Parameters:
    ///   - accountId: Identifier of account which contains balances to be fetched.
    ///   - sendDate: Send time of request.
    /// - Returns: `BalancesDetailsRequest`
    public func buildDetailsRequest(
        accountId: String,
        sendDate: Date
        ) -> BalancesDetailsRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("accounts").addPath(accountId).addPath("balances").addPath("details")
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = BalancesDetailsRequest(
            url: url,
            method: .get,
            signedHeaders: signedHeaders
        )
        
        return request
    }
}

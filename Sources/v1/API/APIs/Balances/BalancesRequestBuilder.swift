import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch balances
public class BalancesRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch balances from api
    /// - Parameters:
    ///   - accountId: Identifier of account which contains balances to be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `BalancesDetailsRequest` or nil.
    public func buildDetailsRequest(
        accountId: String,
        sendDate: Date,
        completion: @escaping (BalancesDetailsRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString

        let url = "\(baseUrl)/v3/accounts/\(accountId)?include=balances.state"
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
}

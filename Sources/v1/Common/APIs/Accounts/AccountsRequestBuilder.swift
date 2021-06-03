import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch account data
@available(*, deprecated, message: "Use AccountsApiV3")
public class AccountsRequestBuilder: BaseApiRequestBuilder {
    
    private let accounts: String = "accounts"
    private let signersPathComponent: String = "signers"
    
    // MARK: - Public
    
    /// Builds request to fetch account data from api
    /// - Parameters:
    ///   - accountId: Identifier of account to be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `AccountRequest` or nil.
    public func buildAccountRequest(
        accountId: String,
        sendDate: Date,
        completion: @escaping (AccountRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.accounts).addPath(accountId)
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to fetch account data from api
    /// - Parameters:
    ///   - accountId: Identifier of account for which signers will be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `SignersRequest` or nil.
    public func buildSignersRequest(
        accountId: String,
        sendDate: Date,
        completion: @escaping (SignersRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.accounts).addPath(accountId).addPath(self.signersPathComponent)
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
}

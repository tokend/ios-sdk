import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch account data
public class AccountsRequestBuilder: BaseApiRequestBuilder {
    
    private let accounts: String = "accounts"
    private let signersPathComponent: String = "signers"
    private let authResultPathComponent: String = "authresult"
    
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
    
    /// Builds request to fetch authentication result
    /// - Parameters:
    ///   - accountId: Identifier of account which was used to perform authentication
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `AuthResultRequest` or nil.
    public func buildAuthRequestRequest(
        accountId: String,
        sendDate: Date,
        completion: @escaping (AuthResultRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.authResultPathComponent).addPath(accountId)
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to post authentication result
    /// - Parameters:
    ///   - accountId: Identifier of account which was used to perform authentication
    ///   - parameters: Parameters that used to define the result of authentication
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `SendAuthResultRequest` or nil.
    public func buildSendAuthRequestRequest(
        accountId: String,
        parameters: SendAuthResultRequestParameters,
        sendDate: Date,
        completion: @escaping (SendAuthResultRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.authResultPathComponent).addPath(accountId)
        
        let parametersEncoding: RequestParametersEncoding = .url
        var parametersDict: RequestParameters = [:]
        
        parametersDict["success"] = parameters.success
        parametersDict["wallet_id"] = parameters.walletId
        
        self.buildRequestParametersSigned(
            baseUrl: baseUrl,
            url: url,
            method: .post,
            sendDate: sendDate,
            parameters: parametersDict,
            parametersEncoding: parametersEncoding,
            completion: completion
        )
    }
}

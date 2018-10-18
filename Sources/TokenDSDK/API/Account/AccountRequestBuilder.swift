import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch account data
public class AccountRequestBuilder: BaseApiRequestBuilder {
    
    private let basePathComponent: String = "accounts"
    private let signersPathComponent: String = "signers"
    
    // MARK: - Public
    
    /// Builds request to fetch account data from api
    /// - Parameters:
    ///   - accountId: Identifier of account to be fetched.
    ///   - sendDate: Send time of request.
    /// - Returns: `AccountRequest`
    public func buildAccountRequest(
        accountId: String,
        sendDate: Date = Date()
        ) -> AccountRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePathComponent).addPath(accountId)
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = AccountRequest(
            url: url,
            method: .get,
            signedHeaders: signedHeaders
        )
        
        return request
    }
    
    /// Builds request to fetch account data from api
    /// - Parameters:
    ///     - accountId: Identifier of account for which signers will be fetched.
    ///     - sendDate: Send time of request.
    /// - Returns: `SignersRequest`
    public func buildSignersRequest(
        accountId: String,
        sendDate: Date = Date()
        ) -> SignersRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePathComponent).addPath(accountId).addPath(self.signersPathComponent)
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = SignersRequest(
            url: url,
            method: .get,
            signedHeaders: signedHeaders
        )
        
        return request
    }
}

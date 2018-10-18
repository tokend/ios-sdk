import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch general data
public class GeneralRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch network info from api.
    /// - Returns: `GetNetworkInfoRequest`
    public func buildGetNetworkInfoRequest() -> GetNetworkInfoRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl
        
        let request = GetNetworkInfoRequest(
            url: url,
            method: .get
        )
        
        return request
    }
    
    /// Builds request to fetch account data by email.
    /// - Parameters:
    ///   - email: Email which will be used to fetch account id.
    /// - Returns: `GetAccountIdRequest`
    public func buildGetAccountIdRequest(email: String) -> GetAccountIdRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("user_id")
        
        let parameters: RequestParameters = [
            "email": email
        ]
        
        let request = GetAccountIdRequest(
            url: url,
            method: .get,
            parameters: parameters,
            parametersEcoding: .urlEncoding
        )
        
        return request
    }
    
    /// Builds request to fetch fee for given amount.
    /// - Parameters:
    ///   - accountId: Identifier of account for which fee should be fetched.
    ///   - asset: Asset of amount for which fee should be fetched.
    ///   - feeType: Type of fee to be fetched.
    ///   - amount: Amount for which fee should be fetched.
    /// - Returns: `GetFeeRequest`
    public func buildGetFeeRequest(
        accountId: String,
        asset: String,
        feeType: FeeResponse.FeeType,
        amount: Decimal?
        ) -> GetFeeRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("fees").addPath("\(feeType.rawValue)")
        
        var parameters: RequestParameters = [
            "account": accountId,
            "asset": asset
        ]
        if let amount = AmountFormatters.sunQueryFormatter.stringFrom(amount) {
            parameters["amount"] = amount
        }
        
        let request = GetFeeRequest(
            url: url,
            method: .get,
            parameters: parameters,
            parametersEcoding: .urlEncoding
        )
        
        return request
    }
}

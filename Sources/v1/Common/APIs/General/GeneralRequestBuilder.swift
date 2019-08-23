import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch general data
public class GeneralRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let identities: String = "identities"
    public let setPhonePath: String = "settings/phone"
    public let setTelegramPath: String = "settings/telegram"
    
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
    
    /// Builds request to fetch identities.
    /// - Parameters:
    ///   - filter: Filter which will be used to fetch identities.
    /// - Returns: `GetIdentitiesRequest`
    public func buildGetIdentitiesRequest(filter: GeneralApi.RequestIdentitiesFilter) -> GetIdentitiesRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.identities)
        
        let parameters: RequestParameters
        switch filter {
        case .accountId(let accountId):
            parameters = [
                "filter[address]": accountId
            ]
        case .email(let email):
            parameters = [
                "filter[email]": email
            ]
        case .phone(let phone):
            parameters = [
                "filter[phone]": phone
            ]
            
        case .telegram(let username):
            parameters = [
                "filter[telegram_username]": username
            ]
        }
        
        let request = GetIdentitiesRequest(
            url: url,
            method: .get,
            parameters: parameters,
            parametersEncoding: .url
        )
        
        return request
    }
    
    /// Builds request to set phone identity.
    /// - Parameters:
    ///   - accountId: Account's identifier.
    ///   - body: Model of `SetPhoneRequestBody` type
    /// - Returns: `SetIdentitiesRequest`
    public func buildSetPhoneIdentityRequest(
        accountId: String,
        body: SetPhoneRequestBody
        ) -> SetIdentitiesRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.identities/accountId/self.setPhonePath
        
        var parameters: [String: Any] = [:]
        if let json = body.toJSON() {
            parameters = json
        }
        
        let request = SetIdentitiesRequest(
            url: url,
            method: .put,
            parameters: parameters,
            parametersEncoding: .json
        )
        
        return request
    }
    
    /// Builds request to set phone identity.
    /// - Parameters:
    ///   - accountId: Account's identifier.
    ///   - body: Model of `SetTelegramRequestBody` type
    /// - Returns: `SetIdentitiesRequest`
    public func buildSetTelegramIdentityRequest(
        accountId: String,
        body: SetTelegramRequestBody
        ) -> SetIdentitiesRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.identities/accountId/self.setTelegramPath
        
        var parameters: [String: Any] = [:]
        if let json = body.toJSON() {
            parameters = json
        }
        
        let request = SetIdentitiesRequest(
            url: url,
            method: .put,
            parameters: parameters,
            parametersEncoding: .json
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
        amount: Decimal?,
        subtype: Int32 = 0
        ) -> GetFeeRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("fees").addPath("\(feeType.rawValue)")
        
        var parameters: RequestParameters = [
            "account": accountId,
            "asset": asset,
            "subtype": subtype
        ]
        if let amount = AmountFormatters.sunQueryFormatter.stringFrom(amount) {
            parameters["amount"] = amount
        }
        
        let request = GetFeeRequest(
            url: url,
            method: .get,
            parameters: parameters,
            parametersEncoding: .url
        )
        
        return request
    }
    
    public func buildGetFeesOverviewRequest() -> GetFeesOverviewRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("fees_overview")
        let request = GetFeesOverviewRequest(
            url: url,
            method: .get
        )
        
        return request
    }
}

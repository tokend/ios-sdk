import Foundation

public class IdentitiesRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Private properties
    
    private let identities: String = "identities"
    private let settings: String = "settings"
    private let phone: String = "phone"
    private let telegram: String = "telegram"
    
}

// MARK: - Public methods

public extension IdentitiesRequestBuilder {
    
    /// Builds request to get list of identities.
    /// One of filters must be set.
    /// - Parameters:
    ///   - filter: Filter which will be used to fetch identities.
    /// - Returns: `GetIdentitiesRequest`
    func buildGetIdentitiesRequest(
        filter: IdentitiesApi.RequestIdentitiesFilter
    ) -> RequestParametersPlain {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.identities
        
        let key: String
        let value: Any
        
        switch filter {
        case .accountId(let accountId):
            key = "address"
            value = accountId
        case .login(let login):
            key = "identifier"
            value = login
        case .phone(let phone):
            key = "email"
            value = phone
            
        case .telegram(let username):
            key = "telegram_username"
            value = username
            
        case .custom(let k, let v):
            key = k
            value = v
        }
        
        let parameters: RequestParameters = ["filter[\(key)]": value]
        
        let request = RequestParametersPlain(
            url: url,
            method: .get,
            parameters: parameters,
            parametersEncoding: .url
        )
        
        return request
    }
    
    /// Builds request to create identity with status `unregistered` and account with one system signer.
    /// - body: Model of `AddIdentityRequestBody` type
    /// - Returns: `AddIdentityRequest`
    func buildAddIdentityRequest(
        bodyParameters: [String: Any]
    ) -> RequestParametersPlain {
        
        let baseUrl = self.apiConfiguration.urlString
        let path = baseUrl/self.identities
        
        let request = RequestParametersPlain(
            url: path,
            method: .post,
            parameters: bodyParameters,
            parametersEncoding: .json
        )
        
        return request
    }
    
    func buildDeleteIdentityRequest(
        accountId: String,
        sendDate: Date,
        completion: @escaping (RequestSigned?) -> Void
    ) {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.identities/accountId
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .delete,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to add or change user's phone number.
    /// - Parameters:
    ///   - accountId: Account's identifier.
    ///   - bodyParameters: Model of `SetPhoneRequestBody` type
    /// - Returns: `SetIdentitiesRequest`
    func buildSetPhoneIdentityRequest(
        accountId: String,
        bodyParameters: [String: Any]
        ) -> RequestParametersPlain {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.identities/accountId/self.settings/self.phone
        
        let request = RequestParametersPlain(
            url: url,
            method: .put,
            parameters: bodyParameters,
            parametersEncoding: .json
        )
        
        return request
    }
    
    /// Builds request to add or change user's telegram username.
    /// - Parameters:
    ///   - accountId: Account's identifier.
    ///   - bodyParameters: Model of `SetTelegramRequestBody` type
    /// - Returns: `SetIdentitiesRequest`
    func buildSetTelegramIdentityRequest(
        accountId: String,
        bodyParameters: [String: Any]
        ) -> RequestParametersPlain {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.identities/accountId/self.settings/self.telegram
        
        let request = RequestParametersPlain(
            url: url,
            method: .put,
            parameters: bodyParameters,
            parametersEncoding: .json
        )
        
        return request
    }
}

import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch account data
public class IntegrationsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    private let clients: String = "clients"
    private let businesses: String = "businesses"
    private let integrations: String = "integrations"
    private let dns: String = "dns"
    private let paymentProxyInfo: String = "payment-proxy/info"
    
    // MARK: - Public
    
    /// Builds request to fetch businesses for client
    /// - Parameters:
    ///   - accountId: Identifier of account for which businesses should be fetched.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildBusinessesRequest(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = self.integrations/self.dns/self.clients/accountId/self.businesses
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to fetch business
    /// - Parameters:
    ///   - accountId: Identifier of businesses account to be fetched.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildBusinessRequest(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = self.integrations/self.dns/self.businesses/accountId
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to add business for client
    /// - Parameters:
    ///   - clientAccountId: Identifier of account for which business should be added.
    ///   - businessAccountId: Identifier of businesses account to be added.
    ///   - body: Body of request.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildAddBusinessesRequest(
        clientAccountId: String,
        businessAccountId: String,
        body: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = self.integrations/self.dns/self.clients/clientAccountId/self.businesses
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleBody(
                path: path,
                method: .post,
                bodyParameters: body
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to get proxy account
    /// - Parameters:
    ///   - completion: Returns `RequestModel` or nil.
    public func buildGetProxyAccountRequest(
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = self.integrations/self.paymentProxyInfo
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: false,
            sendDate: Date(),
            completion: completion
        )
    }
}

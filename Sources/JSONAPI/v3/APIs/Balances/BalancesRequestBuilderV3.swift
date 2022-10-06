import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch balances
public class BalancesRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let balances = "balances"
    
    // MARK: - Public
    
    /// Builds request to fetch balances from api
    /// - Parameters:
    ///   - accountId: If present, the result will contain only balances owned by specified account.
    ///   - asset: If present, the result will contain only balances of specified asset.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildDetailsRequest(
        accountId: String?,
        asset: String?,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = self.v3/self.balances
        
        var parameters = RequestQueryParameters()
        
        if let accountId = accountId {
            parameters["account"] = accountId
        }
        
        if let asset = asset {
            parameters["asset"] = asset
        }
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQuery(
                path: path,
                method: .get,
                queryParameters: parameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to fetch balance from api
    /// - Parameters:
    ///   - balanceId: The id of the requested balance.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildDetailsRequest(
        balanceId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = self.v3/self.balances/balanceId
        
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
}

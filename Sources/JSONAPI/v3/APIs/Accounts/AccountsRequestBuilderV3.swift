import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch account data
public class AccountsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties

    private let accounts = "accounts"
    private let signers = "signers"
    
    // MARK: - Public
    
    /// Builds request to fetch account data from api
    /// - Parameters:
    ///   - accountId: Identifier of account to be fetched.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildAccountRequest(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.accounts/accountId
        
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
    
    /// Builds request to fetch signers for exact account
    /// - Parameters:
    ///   - accountId: Identifier of account for which signers to be fetched.
    ///   - completion: Returns `RequestModel` or nil.
    public func buildSignersRequest(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.accounts/accountId/self.signers
        
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

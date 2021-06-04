import Foundation

/// Class provides functionality that allows to build requests
/// which are used to perform TFA actions
public class TFARequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Internal properties
    
    internal let wallets: String = "wallets"
    internal let factors: String = "factors"
    internal let verification: String = "verification"
    
}

// MARK: - Public methods

public extension TFARequestBuilder {
    
    /// Method build request that fetches factors.
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factors should be fetched.
    ///   - sendDate: Request's send date.
    ///   - completion: Returns `RequestSigned` or nil.
    func buildGetFactorsRequest(
        walletId: String,
        sendDate: Date,
        completion: @escaping (RequestSigned?) -> Void
    ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.wallets/walletId/self.factors
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Method build request that creates factor.
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be fetched.
    ///   - body: Factor data.
    ///   - sendDate: Request's send date.
    ///   - completion: Returns `RequestDataSigned` or nil.
    func buildCreateFactorRequest(
        walletId: String,
        body: Data,
        sendDate: Date,
        completion: @escaping (RequestDataSigned?) -> Void
    ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.wallets/walletId/self.factors
        
        self.buildRequestDataSigned(
            baseUrl: baseUrl,
            url: url,
            method: .post,
            requestData: body,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Method build request that creates factor.
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be updated.
    ///   - factorId: Identifier of factor that should be updated.
    ///   - body: Factor data.
    ///   - sendDate: Request's send date.
    ///   - completion: Returns `RequestDataSigned` or nil.
    func buildUpdateFactorRequest(
        walletId: String,
        factorId: Int,
        body: Data,
        sendDate: Date,
        completion: @escaping (RequestDataSigned?) -> Void
    ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.wallets/walletId/self.factors/"\(factorId)"
        
        self.buildRequestDataSigned(
            baseUrl: baseUrl,
            url: url,
            method: .patch,
            requestData: body,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Method build request that deletes factor.
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be deleted.
    ///   - factorId: Identifier of factor that should be deleted.
    ///   - sendDate: Request's send date.
    ///   - completion: Returns `RequestSigned` or nil.
    func buildDeleteFactorRequest(
        walletId: String,
        factorId: Int,
        sendDate: Date,
        completion: @escaping (RequestSigned?) -> Void
    ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.wallets/walletId/self.factors/"\(factorId)"
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .delete,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Method build request that verifies signed token
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which verification should be performed
    ///   - factorId: Identifier of factor that should be used to verify token
    ///   - signedTokenData: Data of token that should be verified
    /// - Returns: `TFAVerifySignedTokenRequest`
    func buildVerifySignedTokenRequest(
        walletId: String,
        factorId: Int,
        signedTokenData: Data
    ) -> RequestData {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.wallets/walletId/self.factors/"\(factorId)"/self.verification
        
        let request = RequestData(
            url: url,
            method: .put,
            requestData: signedTokenData
        )
        
        return request
    }
}

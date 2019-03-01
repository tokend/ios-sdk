import Foundation

/// Class provides functionality that allows to build requests
/// which are used to perform TFA actions
public class TFARequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let basePath: String = "wallets"
    public let factorsPath: String = "factors"
    public let verificationPath: String = "verification"
    
    // MARK: - Public
    
    /// Method build request that fetches factors
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factors should be fetched
    ///   - sendDate: Request's send date
    ///   - completion: Returns `TFAGetFactorsRequest` or nil.
    public func buildGetFactorsRequest(
        walletId: String,
        sendDate: Date,
        completion: @escaping (TFAGetFactorsRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePath)
            .addPath(walletId)
            .addPath(self.factorsPath)
        
        self.buildRequestSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Method build request that creates factor
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be fetched
    ///   - model: Create factor model
    ///   - sendDate: Request's send date
    ///   - completion: Returns `TFACreateFactorRequest` or nil.
    public func buildCreateFactorRequest(
        walletId: String,
        model: TFACreateFactorModel,
        sendDate: Date,
        completion: @escaping (TFACreateFactorRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePath)
            .addPath(walletId)
            .addPath(self.factorsPath)
        
        let requestData = ApiDataRequest<TFACreateFactorModel, WalletInfoModel.Include>(data: model)
        guard let requestDataEncoded = try? requestData.encode() else {
            completion(nil)
            return
        }
        
        self.buildRequestDataSigned(
            baseUrl: baseUrl,
            url: url,
            method: .post,
            requestData: requestDataEncoded,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Method build request that creates factor
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be updated
    ///   - factorId: Identifier of factor that should be updated
    ///   - model: Update model
    ///   - sendDate: Request's send date
    ///   - completion: Returns `TFAUpdateFactorRequest` or nil.
    public func buildUpdateFactorRequest(
        walletId: String,
        factorId: Int,
        model: TFAUpdateFactorModel,
        sendDate: Date,
        completion: @escaping (TFAUpdateFactorRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePath)
            .addPath(walletId)
            .addPath(self.factorsPath)
            .addPath(factorId)
        
        let requestData = ApiDataRequest<TFAUpdateFactorModel, WalletInfoModel.Include>(data: model)
        guard let requestDataEncoded = try? requestData.encode() else {
            completion(nil)
            return
        }
        
        self.buildRequestDataSigned(
            baseUrl: baseUrl,
            url: url,
            method: .patch,
            requestData: requestDataEncoded,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Method build request that deletes factor
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be deleted
    ///   - factorId: Identifier of factor that should be deleted
    ///   - sendDate: Request's send date
    ///   - completion: Returns `TFADeleteFactorRequest` or nil.
    public func buildDeleteFactorRequest(
        walletId: String,
        factorId: Int,
        sendDate: Date,
        completion: @escaping (TFADeleteFactorRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePath)
            .addPath(walletId)
            .addPath(self.factorsPath)
            .addPath(factorId)
        
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
    public func buildVerifySignedTokenRequest(
        walletId: String,
        factorId: Int,
        signedTokenData: Data
        ) -> TFAVerifySignedTokenRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePath)
            .addPath(walletId)
            .addPath(self.factorsPath)
            .addPath(factorId)
            .addPath(self.verificationPath)
        
        let request = TFAVerifySignedTokenRequest(
            url: url,
            method: .put,
            signedTokenData: signedTokenData
        )
        
        return request
    }
}

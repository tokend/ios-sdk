import Foundation

/// Class provides functionality that allows to build requests
/// which are used to perform TFA actions
public class TFARequestBuilder: BaseApiRequestBuilder {
    
    public let basePath: String = "wallets"
    public let factorsPath: String = "factors"
    public let verificationPath: String = "verification"
    
    // MARK: - Public
    
    /// Method build request that fetches factors
    /// - Parameters:
    ///     - walletId: Identifier of wallet for which factors should be fetched
    ///     - sendDate: Request's send date
    /// - Returns: `TFAGetFactorsRequest`
    public func buildGetFactorsRequest(
        walletId: String,
        sendDate: Date = Date()
        ) -> TFAGetFactorsRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePath)
            .addPath(walletId)
            .addPath(self.factorsPath)
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = TFAGetFactorsRequest(
            url: url,
            method: .get,
            signedHeaders: signedHeaders
        )
        
        return request
    }
    
    /// Method build request that creates factor
    /// - Parameters:
    ///     - walletId: Identifier of wallet for which factor should be fetched
    ///     - sendDate: Request's send date
    /// - Returns: `TFACreateFactorRequest`
    public func buildCreateFactorRequest(
        walletId: String,
        model: TFACreateFactorModel,
        sendDate: Date = Date()
        ) throws -> TFACreateFactorRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePath)
            .addPath(walletId)
            .addPath(self.factorsPath)
        
        let requestData = ApiDataRequest(data: model)
        let requestDataEncoded = try requestData.encode()
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = TFACreateFactorRequest(
            url: url,
            method: .post,
            requestData: requestDataEncoded,
            signedHeaders: signedHeaders
        )
        
        return request
    }
    
    /// Method build request that creates factor
    /// - Parameters:
    ///     - walletId: Identifier of wallet for which factor should be updated
    ///     - factorId: Identifier of factor that should be updated
    ///     - model: Update model
    ///     - sendDate: Request's send date
    /// - Returns: `TFAUpdateFactorRequest`
    public func buildUpdateFactorRequest(
        walletId: String,
        factorId: Int,
        model: TFAUpdateFactorModel,
        sendDate: Date = Date()
        ) throws -> TFAUpdateFactorRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePath)
            .addPath(walletId)
            .addPath(self.factorsPath)
            .addPath(factorId)
        
        let requestData = ApiDataRequest(data: model)
        let requestDataEncoded = try requestData.encode()
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = TFAUpdateFactorRequest(
            url: url,
            method: .patch,
            requestData: requestDataEncoded,
            signedHeaders: signedHeaders
        )
        
        return request
    }
    
    /// Method build request that deletes factor
    /// - Parameters:
    ///     - walletId: Identifier of wallet for which factor should be deleted
    ///     - factorId: Identifier of factor that should be deleted
    ///     - sendDate: Request's send date
    /// - Returns: `TFADeleteFactorRequest`
    public func buildDeleteFactorRequest(
        walletId: String,
        factorId: Int,
        sendDate: Date = Date()
        ) -> TFADeleteFactorRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.basePath)
            .addPath(walletId)
            .addPath(self.factorsPath)
            .addPath(factorId)
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = TFADeleteFactorRequest(
            url: url,
            method: .delete,
            signedHeaders: signedHeaders
        )
        
        return request
    }
    
    /// Method build request that verifies signed token
    /// - Parameters:
    ///     - walletId: Identifier of wallet for which verification should be performed
    ///     - factorId: Identifier of factor that should be used to verify token
    ///     - signedTokenData: Data of token that should be verified
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

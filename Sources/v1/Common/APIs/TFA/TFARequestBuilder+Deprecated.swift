import Foundation

public extension TFARequestBuilder {
    
    /// Method build request that creates factor.
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be fetched.
    ///   - model: Create factor model.
    ///   - sendDate: Request's send date.
    ///   - completion: Returns `TFACreateFactorRequest` or nil.
    @available(*, deprecated, renamed: "buildCreateFactorRequest")
    func buildCreateFactorRequest(
        walletId: String,
        model: TFACreateFactorModel,
        sendDate: Date,
        completion: @escaping (RequestDataSigned?) -> Void
    ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.wallets/walletId/self.factors
        
        let requestData = ApiDataRequest<TFACreateFactorModel, WalletInfoModelV2.Include>(data: model)
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
    
    /// Method build request that creates factor.
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be updated.
    ///   - factorId: Identifier of factor that should be updated.
    ///   - model: Update model.
    ///   - sendDate: Request's send date.
    ///   - completion: Returns `TFAUpdateFactorRequest` or nil.
    func buildUpdateFactorRequest(
        walletId: String,
        factorId: Int,
        model: TFAUpdateFactorModel,
        sendDate: Date,
        completion: @escaping (RequestDataSigned?) -> Void
    ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.wallets/walletId/self.factors/"\(factorId)"
        
        let requestData = ApiDataRequest<TFAUpdateFactorModel, WalletInfoModelV2.Include>(data: model)
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
}

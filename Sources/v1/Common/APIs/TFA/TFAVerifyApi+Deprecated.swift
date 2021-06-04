import Foundation

@available(*, deprecated)
public extension TFAVerifyApi {
    
    /// Model that will be fetched in `completion` block of `TFAVerifyApi.verifyTFA(...)`
    @available(*, deprecated, message: "Use verifyTFA instead")
    enum VerifyTFAResult {
        
        /// Case of successful verification
        case success
        
        /// Case of failed verification with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method verifies TFA
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which verification should be performed
    ///   - factorId: Identifier of factor that should be used to verify token
    ///   - signedTokenData: Data of token that should be verified
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `VerifyTFAResult`
    @available(*, deprecated, renamed: "verifyTFA")
    func verifyTFA(
        walletId: String,
        factorId: Int,
        signedTokenData: Data,
        completion: @escaping (_ result: VerifyTFAResult) -> Void
        ) {
        
        let request = self.requestBuilder.buildVerifySignedTokenRequest(
            walletId: walletId,
            factorId: factorId,
            signedTokenData: signedTokenData
        )
        
        self.network.responseDataEmpty(
            url: request.url,
            method: request.method,
            bodyData: signedTokenData,
            completion: { result in
                switch result {
                    
                case .success:
                    completion(.success)
                    
                case .failure(let errors):
                    completion(.failure(errors))
                }
        })
    }
}

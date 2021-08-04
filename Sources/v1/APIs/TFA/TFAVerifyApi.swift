import Foundation

/// Class provides functionality that allows to perform TFA verification
public class TFAVerifyApi {
    
    // MARK: - Public
    
    public let requestBuilder: TFARequestBuilder
    public let network: NetworkFacade
    
    // MARK: -
    
    public init(
        apiConfigurationProvider: ApiConfigurationProviderProtocol,
        requestSigner: RequestSignerProtocol,
        network: NetworkProtocol
        ) {
        
        self.requestBuilder = TFARequestBuilder(
            builderStack: BaseApiRequestBuilderStack(
                apiConfigurationProvider: apiConfigurationProvider,
                requestSigner: requestSigner
            )
        )
        self.network = NetworkFacade(network: network)
    }
}
    
// MARK: - Public methods

public extension TFAVerifyApi {
    
    /// Method verifies TFA
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which verification should be performed
    ///   - factorId: Identifier of factor that should be used to verify token
    ///   - signedTokenData: Data of token that should be verified
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `Swift.Result<Void, Swift.Error>`
    func verifyTFA(
        walletId: String,
        factorId: Int,
        signedTokenData: Data,
        completion: @escaping (Swift.Result<Void, Swift.Error>) -> Void
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
                    completion(.success(()))
                    
                case .failure(let errors):
                    completion(.failure(errors))
                }
        })
    }
}

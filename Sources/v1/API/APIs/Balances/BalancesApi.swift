import Foundation

/// Class provides functionality that allows to fetch balances
public class BalancesApi: BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: BalancesRequestBuilder
    
    // MARK: -
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = BalancesRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in completion block of `BalancesApi.requestDetails(...)`
    public enum RequestDetailsResult {
        
        /// Case of successful response with list of `BalanceDetails`
        case success(balances: [BalanceDetails])
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to get balances for according account from api.
    /// The result of request will be fetched in `completion` block as `BalancesApi.RequestDetailsResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which balances will be fetched.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `BalancesApi.RequestDetailsResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestDetails(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestDetailsResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildDetailsRequest(
            accountId: accountId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    [BalanceDetails].self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    completion: { (result) in
                        switch result {
                            
                        case .success(let objects):
                            completion(.success(balances: objects))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
}

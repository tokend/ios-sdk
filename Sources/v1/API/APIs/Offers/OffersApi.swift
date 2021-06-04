import Foundation

/// Class provides functionality that allows to fetch offers
@available(*, deprecated, message: "Use OffersApiV3")
public class OffersApi: BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: OffersRequestBuilder
    
    // MARK: -
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = OffersRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    /// Model that will be fetched in completion block of `OffersApi.requestOffers(...)`
    public enum RequestOffersResult {
        
        /// Case of successful response with list of `OfferResponse`
        case success(offers: [OfferResponse])
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to send offer.
    /// The result of request will be fetched in `completion` block as `OffersApi.RequestOffersResult`
    /// - Parameters:
    ///   - accountId: Identifier of account from which offer is sended.
    ///   - parameters: Parameters of the offer.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `OffersApi.RequestOffersResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestOffers(
        accountId: String,
        parameters: OffersOffersRequestParameters?,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestOffersResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildOffersRequest(
            accountId: accountId,
            parameters: parameters,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    RequestResultPage<OffersEmbedded>.self,
                    url: request.url,
                    method: request.method,
                    parameters: request.parameters,
                    encoding: request.parametersEncoding,
                    headers: request.signedHeaders,
                    completion: { (result) in
                        switch result {
                            
                        case .success(let object):
                            completion(.success(offers: object.embedded.records))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
}

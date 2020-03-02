import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch account data
public class IntegrationsApiV3: JSONAPI.BaseApi {
    
    public let requestBuilder: IntegrationsRequestBuilderV3
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = IntegrationsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to get businesses for exact account.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - accountId: Identifier of account for which businesses should be fetched.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<BusinessResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestBusinesses(
        accountId: String,
        completion: @escaping (_ result: RequestCollectionResult<BusinessResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildBusinessesRequest(
            accountId: accountId,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    BusinessResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })
        
        return cancelable
    }
    
    /// Method sends request to get businesses for exact account.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - accountId: Identifier of account for which businesses should be fetched.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<BusinessResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestProxyPaymentAccount(
        completion: @escaping (_ result: RequestSingleResult<PaymentAccountResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetProxyAccountRequest(
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    PaymentAccountResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })
        
        return cancelable
    }
    
    /// Method sends request to get business by id.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - accountId: Identifier of the business to be fetched.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<BusinessResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestBusiness(
        accountId: String,
        completion: @escaping (_ result: RequestSingleResult<BusinessResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildBusinessRequest(
            accountId: accountId,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    BusinessResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })
        
        return cancelable
    }
    
    /// Method sends request to add business for exact account.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - clientAccountId: Identifier of account for which business should be added.
    ///   - businessAccountId: Identifier of businesses account to be added.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<RequestEmptyResult>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func addBusinesses(
        clientAccountId: String,
        businessAccountId: String,
        completion: @escaping (_ result: RequestEmptyResult) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        let businessResource = BusinessResource()
        businessResource.id = businessAccountId
        
        guard let body = try? businessResource.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }
        
        self.requestBuilder.buildAddBusinessesRequest(
            clientAccountId: clientAccountId,
            businessAccountId: businessAccountId,
            body: body,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success:
                            completion(.success)
                        }
                })
        })
        
        return cancelable
    }
    
    /// Method sends atomic swap buy request.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - envelope: Transaction's envelope.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<BusinessResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func sendAtomicSwapBuyRequest(
        envelope: String,
        completion: @escaping (_ result: RequestSingleResult<AtomicSwapBuyResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildSendAtomicSwapBuyRequest(
            envelope: envelope,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    AtomicSwapBuyResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })
        
        return cancelable
    }
    
}

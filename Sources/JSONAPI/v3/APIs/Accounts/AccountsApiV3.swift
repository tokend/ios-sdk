import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch account data
public class AccountsApiV3: JSONAPI.BaseApi {
    
    public let requestBuilder: AccountsRequestBuilderV3
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = AccountsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to get account data from api.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - accountId: Identifier of account to be fetched.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<Horizon.AccountResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAccount(
        accountId: String,
        include: [String]?,
        pagination: RequestPagination?,
        completion: @escaping (_ result: RequestSingleResult<Horizon.AccountResource>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildAccountRequest(
            accountId: accountId,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    Horizon.AccountResource.self,
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
    
    /// Method sends request to get signers for exact account.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - accountId: Identifier of account fro which signers to be fetched.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<SignerResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestSigners(
        accountId: String,
        completion: @escaping (_ result: RequestCollectionResult<Horizon.SignerResource>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildSignersRequest(
            accountId: accountId,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    Horizon.SignerResource.self,
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
    
    /// Returns the list of the reviewable requests.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<ReviewableRequestResource>`.
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestChangeRoleRequests(
        filters: ChangeRoleRequestsFiltersV3,
        include: [String]? = nil,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping (_ result: RequestCollectionResult<Horizon.ReviewableRequestResource>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildChangeRoleRequestsRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                onRequestBuilt?(request)
                
                cancelable.cancelable = self?.requestCollection(
                    Horizon.ReviewableRequestResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
    
    /// Returns the specified reviewable request.
    /// - Parameters:
    ///   - accountId: Account id for which request will be fetched.
    ///   - requestId: Id of request to be fetched.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<ReviewableRequestResource>`.
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAccountRequest(
        accountId: String,
        requestId: String,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping (_ result: RequestSingleResult<Horizon.ReviewableRequestResource>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildRequestRequest(
            accountId: accountId,
            requestId: requestId,
            pagination: pagination,
            completion: { (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self.requestSingle(
                    Horizon.ReviewableRequestResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
    
    /// Returns the specified reviewable request.
    /// - Parameters:
    ///   - accountId: Account id for which request will be fetched.
    ///   - convertationAsset: Asset to be converted in.
    ///   - include: Resource to include.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<ConvertedBalancesCollectionResource>`.
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestConvertedBalances(
        accountId: String,
        convertationAsset: String,
        include: [String]?,
        completion: @escaping (_ result: RequestSingleResult<Horizon.ConvertedBalancesCollectionResource>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildConvertedBalancesRequest(
            accountId: accountId,
            convertationAsset: convertationAsset,
            include: include,
            completion: { (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self.requestSingle(
                    Horizon.ConvertedBalancesCollectionResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
}

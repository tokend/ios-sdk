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
    
    /// Model that will be fetched in `completion` block of ` AccountsApiV3.requestAccount(...)`
    public enum RequestAccountResult<AccountResourceType: AccountResource> {
        
        /// Errors that are possible to be fetched.
        public enum RequestError: Swift.Error, LocalizedError {
            
            /// Indicating that corresponding account doesn't exist
            case accountNotCreated
            
            /// Other errors
            case other(Error)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                    
                case .accountNotCreated:
                    return "Account doesn't exist"
                    
                case .other(let error):
                    return error.localizedDescription
                }
            }
        }
        
        /// Case of successful response with document which contains list of `ResourceType`
        case success(Document<AccountResourceType>)
        
        /// Case of failed response with `ErrorObject` model
        case failure(RequestError)
    }
    
    /// Method sends request to get account data from api.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - accountId: Identifier of account to be fetched.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestAccountResult<AccountResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAccount(
        accountId: String,
        include: [String]?,
        pagination: RequestPagination?,
        completion: @escaping (_ result: RequestSingleResult<AccountResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
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
                    AccountResource.self,
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
        completion: @escaping (_ result: RequestCollectionResult<SignerResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildSignersRequest(
            accountId: accountId,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    SignerResource.self,
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
        completion: @escaping (_ result: RequestCollectionResult<ReviewableRequestResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
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
                    ReviewableRequestResource.self,
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
        completion: @escaping (_ result: RequestSingleResult<ReviewableRequestResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
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
                    ReviewableRequestResource.self,
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
        completion: @escaping (_ result: RequestSingleResult<ConvertedBalancesCollectionResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
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
                    ConvertedBalancesCollectionResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
}

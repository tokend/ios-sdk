import Foundation

/// Class provides functionality that allows to perform TFA operations
public class TFAApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: TFARequestBuilder
    public let network: NetworkFacade
    public let verifyApi: TFAVerifyApi
    public let tfaHandler: TFAHandlerProtocol
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        requestSigner: RequestSignerProtocol,
        callbacks: ApiCallbacks,
        network: NetworkProtocol
        ) {
        self.requestBuilder = TFARequestBuilder(
            builderStack: BaseApiRequestBuilderStack.init(
                apiConfiguration: apiConfiguration,
                requestSigner: requestSigner
            )
        )
        self.network = NetworkFacade(network: network)
        self.verifyApi = TFAVerifyApi(
            apiConfiguration: apiConfiguration,
            requestSigner: requestSigner,
            network: self.network.network
        )
        self.tfaHandler = TFAHandler(
            callbacks: callbacks,
            verifyApi: self.verifyApi
        )
    }
    
    // MARK: - Public
    
    // MARK: Get Factors
    
    /// Model that will be fetched in `completion` block
    /// of `TFAApi.getFactors(...)`
    public enum GetFactorsResult {
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
        
        /// Case of successful response with list of `TFAFactor` models
        case success(factors: [TFAFactor])
    }
    
    /// Method gets factor which is used in wallet with exact `walletId`
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factors should be fetched
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `GetFactorsResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getFactors(
        walletId: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: GetFactorsResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetFactorsRequest(
            walletId: walletId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    ApiDataResponse<[TFAFactor]>.self,
                    url: request.url,
                    method: request.method,
                    headers: request.signedHeaders,
                    completion: { (result) in
                        switch result {
                            
                        case .success(let object):
                            completion(.success(factors: object.data))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
    
    // MARK: Create
    
    /// Model that will be fetched in `completion` block
    /// of `TFAApi.createFactor(...)`
    public enum CreateFactorResult {
        /// Errors that are might be fetched while creating factor
        public enum CreateError: Swift.Error, LocalizedError {
            case factorAlreadyExists
            case other(ApiErrors)
            case tfaFailed
            case tfaCancelled
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .factorAlreadyExists:
                    return "Factor already exists"
                case .other(let errors):
                    return errors.localizedDescription
                case .tfaFailed:
                    return "TFA failed"
                case .tfaCancelled:
                    return "TFA cancelled"
                }
            }
        }
        
        /// Case of failed response with `CreateError` model
        case failure(CreateError)
        
        /// Case of successful response with `TFACreateFactorResponse` model
        case success(TFACreateFactorResponse)
    }
    
    /// Method creates factor which will be used in wallet with exact `walletId`
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be created
    ///   - type: Type of factor
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `CreateFactorResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func createFactor(
        walletId: String,
        type: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: CreateFactorResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let model = TFACreateFactorModel(type: type)
        
        self.requestBuilder.buildCreateFactorRequest(
            walletId: walletId,
            model: model,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.other(.failedToSignRequest)))
                    return
                }
                
                cancelable.cancelable = self?.createFactor(
                    request: request,
                    initiateTFA: true,
                    completion: completion
                    )
        })
        
        return cancelable
    }
    
    // MARK: Update
    
    /// Model that will be fetched in `completion` block
    /// of `TFAApi.updateFactor(...)`
    public enum UpdateFactorResult {
        /// Errors that are might be fetched while updating factor
        public enum UpdateError: Swift.Error, LocalizedError {
            case other(ApiErrors)
            case tfaFailed
            case tfaCancelled
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .other(let errors):
                    return errors.localizedDescription
                case .tfaFailed:
                    return "TFA failed"
                case .tfaCancelled:
                    return "TFA cancelled"
                }
            }
        }
        
        /// Case of failed response with `UpdateError` model
        case failure(UpdateError)
        
        /// Case of successful response
        case success
    }
    
    /// Method updates factor with `factorId` which is used in wallet with `walletId`
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be updated
    ///   - factorId: Identifier of factor that should be updated
    ///   - priority: Factor priority
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `UpdateFactorResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func updateFactor(
        walletId: String,
        factorId: Int,
        priority: Int,
        sendDate: Date = Date(),
        completion: @escaping (_ result: UpdateFactorResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let attributes = TFAUpdateFactorModel.Attributes(priority: priority)
        let model = TFAUpdateFactorModel(attributes: attributes)
        
        self.requestBuilder.buildUpdateFactorRequest(
            walletId: walletId,
            factorId: factorId,
            model: model,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.other(.failedToSignRequest)))
                    return
                }
                
                cancelable.cancelable = self?.updateFactor(
                    request: request,
                    initiateTFA: true,
                    completion: completion
                    )
        })
        
        return cancelable
    }
    
    // MARK: Delete
    
    /// Model that will be fetched in `completion` block
    /// of `TFAApi.deleteFactor(...)`
    public enum DeleteFactorResult {
        /// Errors that are might be fetched while deleting factor
        public enum DeleteError: Swift.Error, LocalizedError {
            case tfaFailed
            case tfaCancelled
            case other(ApiErrors)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .other(let errors):
                    return errors.localizedDescription
                case .tfaFailed:
                    return "TFA failed"
                case .tfaCancelled:
                    return "TFA cancelled"
                }
            }
        }
        
        /// Case of failed response with `DeleteError` model
        case failure(DeleteError)
        
        /// Case of successful response
        case success
    }
    
    /// Method deletes factor with `factorId` which is used in wallet with `walletId`
    /// - Parameters:
    ///   - walletId: Wallet identifier
    ///   - factorId: Factor identifier
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `DeleteFactorResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func deleteFactor(
        walletId: String,
        factorId: Int,
        sendDate: Date = Date(),
        completion: @escaping (_ result: DeleteFactorResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildDeleteFactorRequest(
            walletId: walletId,
            factorId: factorId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.other(.failedToSignRequest)))
                    return
                }
                
                cancelable.cancelable = self?.deleteFactor(
                    request: request,
                    initiateTFA: true,
                    completion: completion
                    )
        })
        
        return cancelable
    }
    
    // MARK: - Private
    
    private func createFactor(
        request: TFACreateFactorRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: CreateFactorResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        cancelable.cancelable = self.network.responseDataObject(
            ApiDataResponse<TFACreateFactorResponse>.self,
            url: request.url,
            method: request.method,
            headers: request.signedHeaders,
            bodyData: request.requestData,
            completion: { [weak self] (result) in
                switch result {
                    
                case .success(let object):
                    completion(.success(object.data))
                    
                case .failure(let errors):
                    guard let sself = self else {
                        completion(.failure(.other(errors)))
                        return
                    }
                    
                    errors.checkTFARequired(
                        handler: sself.tfaHandler,
                        initiateTFA: initiateTFA,
                        onCompletion: { (tfaResult) in
                            switch tfaResult {
                                
                            case .success:
                                cancelable.cancelable = self?.createFactor(
                                    request: request,
                                    initiateTFA: false,
                                    completion: completion
                                    )
                                
                            case .failure:
                                completion(.failure(.tfaFailed))
                                
                            case .canceled:
                                completion(.failure(.tfaCancelled))
                            }
                    },
                        onNoTFA: {
                            if errors.contains(status: ApiError.Status.conflict) {
                                completion(.failure(.factorAlreadyExists))
                            } else {
                                completion(.failure(.other(errors)))
                            }
                    })
                }
        })
        
        return cancelable
    }
    
    private func updateFactor(
        request: TFAUpdateFactorRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: UpdateFactorResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        cancelable.cancelable = self.network.responseDataEmpty(
            url: request.url,
            method: request.method,
            headers: request.signedHeaders,
            bodyData: request.requestData,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let errors):
                    guard let sself = self else {
                        completion(.failure(.other(errors)))
                        return
                    }
                    
                    errors.checkTFARequired(
                        handler: sself.tfaHandler,
                        initiateTFA: initiateTFA,
                        onCompletion: { (tfaResult) in
                            switch tfaResult {
                                
                            case .success:
                                cancelable.cancelable = self?.updateFactor(
                                    request: request,
                                    initiateTFA: false,
                                    completion: completion
                                    )
                                
                            case .failure:
                                completion(.failure(.tfaFailed))
                                
                            case .canceled:
                                completion(.failure(.tfaCancelled))
                            }
                    },
                        onNoTFA: {
                            completion(.failure(.other(errors)))
                    })
                    
                case .success:
                    completion(.success)
                }
        })
        
        return cancelable
    }
    
    private func deleteFactor(
        request: TFADeleteFactorRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: DeleteFactorResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        cancelable.cancelable = self.network.responseDataEmpty(
            url: request.url,
            method: request.method,
            headers: request.signedHeaders,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let errors):
                    guard let sself = self else {
                        completion(.failure(.other(errors)))
                        return
                    }
                    
                    errors.checkTFARequired(
                        handler: sself.tfaHandler,
                        initiateTFA: initiateTFA,
                        onCompletion: { (tfaResult) in
                            switch tfaResult {
                                
                            case .success:
                                cancelable.cancelable = self?.deleteFactor(
                                    request: request,
                                    initiateTFA: false,
                                    completion: completion
                                    )
                                
                            case .failure:
                                completion(.failure(.tfaFailed))
                                
                            case .canceled:
                                completion(.failure(.tfaCancelled))
                            }
                    },
                        onNoTFA: {
                            completion(.failure(.other(errors)))
                    })
                    
                case .success:
                    completion(.success)
                }
        })
        
        return cancelable
    }
}

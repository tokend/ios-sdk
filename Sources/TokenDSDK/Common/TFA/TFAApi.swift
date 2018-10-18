import Foundation

/// Class provides functionality that allows to perform TFA operations
public class TFAApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: TFARequestBuilder
    public let network: Network
    public let verifyApi: TFAVerifyApi
    public let tfaHandler: TFAHandlerProtocol
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        requestSigner: RequestSignerProtocol,
        callbacks: ApiCallbacks
        ) {
        self.requestBuilder = TFARequestBuilder(
            builderStack: BaseApiRequestBuilderStack.init(
                apiConfiguration: apiConfiguration,
                requestSigner: requestSigner
            )
        )
        self.network = Network(userAgent: apiConfiguration.userAgent)
        self.verifyApi = TFAVerifyApi(
            apiConfiguration: apiConfiguration,
            requestSigner: requestSigner
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
    ///     - walletId: Identifier of wallet for which factors should be fetched
    ///     - completion: The block which is called when the result of request is fetched
    ///     - result: The member of `GetFactorsResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func getFactors(
        walletId: String,
        completion: @escaping (_ result: GetFactorsResult) -> Void
        ) -> CancellableToken {
        
        let request = self.requestBuilder.buildGetFactorsRequest(walletId: walletId, sendDate: Date())
        
        return self.network.responseObject(
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
    }
    
    // MARK: Create
    
    /// Model that will be fetched in `completion` block
    /// of `TFAApi.createFactor(...)`
    public enum CreateFactorResult {
        /// Errors that are might be fetched while creating factor
        public enum CreateError: Swift.Error, LocalizedError {
            case factorAlreadyExists
            case modelEncodeFailed(Swift.Error)
            case other(ApiErrors)
            case tfaFailed
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .factorAlreadyExists:
                    return "Factor already exists"
                case .modelEncodeFailed(let error):
                    return error.localizedDescription
                case .other(let errors):
                    return errors.localizedDescription
                case .tfaFailed:
                    return "TFA failed"
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
    ///     - walletId: Identifier of wallet for which factor should be created
    ///     - type: Type of factor
    ///     - completion: The block which is called when the result of request is fetched
    ///     - result: The member of `CreateFactorResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func createFactor(
        walletId: String,
        type: String,
        completion: @escaping (_ result: CreateFactorResult) -> Void
        ) -> CancellableToken {
        
        let model = TFACreateFactorModel(type: type)
        
        let request: TFACreateFactorRequest
        do {
            request = try self.requestBuilder.buildCreateFactorRequest(
                walletId: walletId,
                model: model,
                sendDate: Date()
            )
        } catch let error {
            completion(.failure(.modelEncodeFailed(error)))
            return CancellableToken(request: nil)
        }
        
        return self.createFactor(
            request: request,
            initiateTFA: true,
            completion: completion
        )
    }
    
    // MARK: Update
    
    /// Model that will be fetched in `completion` block
    /// of `TFAApi.updateFactor(...)`
    public enum UpdateFactorResult {
        /// Errors that are might be fetched while updating factor
        public enum UpdateError: Swift.Error, LocalizedError {
            case modelEncodeFailed(Swift.Error)
            case other(ApiErrors)
            case tfaFailed
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .modelEncodeFailed(let error):
                    return error.localizedDescription
                case .other(let errors):
                    return errors.localizedDescription
                case .tfaFailed:
                    return "TFA failed"
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
    ///     - walletId: Identifier of wallet for which factor should be updated
    ///     - factorId: Identifier of factor that should be updated
    ///     - priority: Factor priority
    ///     - completion: The block which is called when the result of request is fetched
    ///     - result: The member of `UpdateFactorResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func updateFactor(
        walletId: String,
        factorId: Int,
        priority: Int,
        completion: @escaping (_ result: UpdateFactorResult) -> Void
        ) -> CancellableToken {
        
        let attributes = TFAUpdateFactorModel.Attributes(priority: priority)
        let model = TFAUpdateFactorModel(attributes: attributes)
        
        let request: TFAUpdateFactorRequest
        do {
            request = try self.requestBuilder.buildUpdateFactorRequest(
                walletId: walletId,
                factorId: factorId,
                model: model,
                sendDate: Date()
            )
        } catch let error {
            completion(.failure(.modelEncodeFailed(error)))
            return CancellableToken(request: nil)
        }
        
        return self.updateFactor(
            request: request,
            initiateTFA: true,
            completion: completion
        )
    }
    
    // MARK: Delete
    
    /// Model that will be fetched in `completion` block
    /// of `TFAApi.deleteFactor(...)`
    public enum DeleteFactorResult {
        /// Errors that are might be fetched while deleting factor
        public enum DeleteError: Swift.Error, LocalizedError {
            case tfaFailed
            case other(ApiErrors)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .other(let errors):
                    return errors.localizedDescription
                case .tfaFailed:
                    return "TFA failed"
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
    ///     - walletId: Wallet identifier
    ///     - factorId: Factor identifier
    ///     - completion: The block which is called when the result of request is fetched
    ///     - result: The member of `DeleteFactorResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func deleteFactor(
        walletId: String,
        factorId: Int,
        completion: @escaping (_ result: DeleteFactorResult) -> Void
        ) -> CancellableToken {
        
        let request = self.requestBuilder.buildDeleteFactorRequest(
            walletId: walletId,
            factorId: factorId,
            sendDate: Date()
        )
        
        return self.deleteFactor(
            request: request,
            initiateTFA: true,
            completion: completion
        )
    }
    
    // MARK: - Private
    
    private func createFactor(
        request: TFACreateFactorRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: CreateFactorResult) -> Void
        ) -> CancellableToken {
        
        let cancellableToken = CancellableToken(request: nil)
        
        cancellableToken.request = self.network.responseDataObject(
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
                                cancellableToken.request = self?.createFactor(
                                    request: request,
                                    initiateTFA: false,
                                    completion: completion
                                    ).request
                                
                            case .failure, .canceled:
                                completion(.failure(.tfaFailed))
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
        }).request
        
        return cancellableToken
    }
    
    private func updateFactor(
        request: TFAUpdateFactorRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: UpdateFactorResult) -> Void
        ) -> CancellableToken {
        
        let cancellableToken = CancellableToken(request: nil)
        
        cancellableToken.request = self.network.responseDataEmpty(
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
                                cancellableToken.request = self?.updateFactor(
                                    request: request,
                                    initiateTFA: false,
                                    completion: completion
                                    ).request
                                
                            case .failure, .canceled:
                                completion(.failure(.tfaFailed))
                            }
                    },
                        onNoTFA: {
                            completion(.failure(.other(errors)))
                    })
                    
                case .success:
                    completion(.success)
                }
        }).request
        
        return cancellableToken
    }
    
    private func deleteFactor(
        request: TFADeleteFactorRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: DeleteFactorResult) -> Void
        ) -> CancellableToken {
        
        let cancellableToken = CancellableToken(request: nil)
        
        cancellableToken.request = self.network.responseDataEmpty(
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
                                cancellableToken.request = self?.deleteFactor(
                                    request: request,
                                    initiateTFA: false,
                                    completion: completion
                                    ).request
                                
                            case .failure, .canceled:
                                completion(.failure(.tfaFailed))
                            }
                    },
                        onNoTFA: {
                            completion(.failure(.other(errors)))
                    })
                    
                case .success:
                    completion(.success)
                }
        }).request
        
        return cancellableToken
    }
}

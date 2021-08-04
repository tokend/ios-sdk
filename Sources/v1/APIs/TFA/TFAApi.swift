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
        apiConfigurationProvider: ApiConfigurationProviderProtocol,
        requestSigner: RequestSignerProtocol,
        callbacks: ApiCallbacks,
        network: NetworkProtocol
        ) {
        self.requestBuilder = TFARequestBuilder(
            builderStack: BaseApiRequestBuilderStack.init(
                apiConfigurationProvider: apiConfigurationProvider,
                requestSigner: requestSigner
            )
        )
        self.network = NetworkFacade(network: network)
        self.verifyApi = TFAVerifyApi(
            apiConfigurationProvider: apiConfigurationProvider,
            requestSigner: requestSigner,
            network: self.network.network
        )
        self.tfaHandler = TFAHandler(
            callbacks: callbacks,
            verifyApi: self.verifyApi
        )
    }
}
    
// MARK: - Public methods

public extension TFAApi {
    
    /// Method gets factor which is used in wallet with exact `walletId`
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factors should be fetched
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `Swift.Result<[TFAFactor], Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func getFactors(
        walletId: String,
        sendDate: Date = Date(),
        completion: @escaping (Swift.Result<[TFAFactor], Swift.Error>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetFactorsRequest(
            walletId: walletId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
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
                            completion(.success(object.data))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
    
    enum CreateFactorError: Swift.Error, LocalizedError {
        
        case factorAlreadyExists
        case tfaFailed
        case tfaCancelled
        
        // MARK: - Swift.Error
        
        public var errorDescription: String? {
            switch self {
            case .factorAlreadyExists:
                return "Factor already exists"
            case .tfaFailed:
                return "TFA failed"
            case .tfaCancelled:
                return "TFA cancelled"
            }
        }
    }
    /// Method creates factor which will be used in wallet with exact `walletId`
    /// - Parameters:
    ///   - walletId: Identifier of wallet for which factor should be created
    ///   - type: Type of factor
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `Swift.Result<TFACreateFactorResponse, Swift.Error>`
    /// - Returns: `Cancelable`
    @discardableResult
    func createFactor(
        walletId: String,
        type: String,
        sendDate: Date = Date(),
        completion: @escaping (Swift.Result<TFACreateFactorResponse, Swift.Error>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let body = ApiDataRequest<TFACreateFactorModel, WalletInfoModelV2.Include>(
            data: TFACreateFactorModel(
                type: type
            )
        )

        let encodedRequest: Data
        do {
            encodedRequest = try body.encode()
        } catch {
            completion(.failure(error))
            return network.getEmptyCancelable()
        }
        
        self.requestBuilder.buildCreateFactorRequest(
            walletId: walletId,
            body: encodedRequest,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
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
    
    enum UpdateFactorError: Swift.Error, LocalizedError {
        
        case tfaFailed
        case tfaCancelled
        
        // MARK: - Swift.Error
        
        public var errorDescription: String? {
            switch self {
            case .tfaFailed:
                return "TFA failed"
            case .tfaCancelled:
                return "TFA cancelled"
            }
        }
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
    func updateFactor(
        walletId: String,
        factorId: Int,
        priority: Int,
        sendDate: Date = Date(),
        completion: @escaping (Swift.Result<Void, Swift.Error>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let attributes = TFAUpdateFactorModel.Attributes(priority: priority)
        let body = ApiDataRequest<TFAUpdateFactorModel, WalletInfoModelV2.Include>(
            data: TFAUpdateFactorModel(
                attributes: attributes
            )
        )
        
        let encodedRequest: Data
        do {
            encodedRequest = try body.encode()
        } catch {
            completion(.failure(error))
            return network.getEmptyCancelable()
        }
        
        self.requestBuilder.buildUpdateFactorRequest(
            walletId: walletId,
            factorId: factorId,
            body: encodedRequest,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
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
    
    enum DeleteFactorError: Swift.Error, LocalizedError {
        
        case tfaFailed
        case tfaCancelled
        
        // MARK: - Swift.Error
        
        public var errorDescription: String? {
            switch self {
            case .tfaFailed:
                return "TFA failed"
            case .tfaCancelled:
                return "TFA cancelled"
            }
        }
    }
    /// Method deletes factor with `factorId` which is used in wallet with `walletId`
    /// - Parameters:
    ///   - walletId: Wallet identifier
    ///   - factorId: Factor identifier
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `DeleteFactorResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func deleteFactor(
        walletId: String,
        factorId: Int,
        sendDate: Date = Date(),
        completion: @escaping (Swift.Result<Void, Swift.Error>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildDeleteFactorRequest(
            walletId: walletId,
            factorId: factorId,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(ApiErrors.failedToSignRequest))
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
}
    
// MARK: - Private methods

private extension TFAApi {
    
    func createFactor(
        request: RequestDataSigned,
        initiateTFA: Bool,
        completion: @escaping (Swift.Result<TFACreateFactorResponse, Swift.Error>) -> Void
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
                        completion(.failure(errors))
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
                                completion(.failure(CreateFactorError.tfaFailed))
                                
                            case .canceled:
                                completion(.failure(CreateFactorError.tfaCancelled))
                            }
                    },
                        onNoTFA: {
                            if errors.contains(status: ApiError.Status.conflict) {
                                completion(.failure(CreateFactorError.factorAlreadyExists))
                            } else {
                                completion(.failure(errors))
                            }
                    })
                }
        })
        
        return cancelable
    }
    
    func updateFactor(
        request: RequestDataSigned,
        initiateTFA: Bool,
        completion: @escaping (Swift.Result<Void, Swift.Error>) -> Void
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
                        completion(.failure(errors))
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
                                completion(.failure(UpdateFactorError.tfaFailed))
                                
                            case .canceled:
                                completion(.failure(UpdateFactorError.tfaCancelled))
                            }
                    },
                        onNoTFA: {
                            completion(.failure(errors))
                    })
                    
                case .success:
                    completion(.success(()))
                }
        })
        
        return cancelable
    }
    
    func deleteFactor(
        request: RequestSigned,
        initiateTFA: Bool,
        completion: @escaping (Swift.Result<Void, Swift.Error>) -> Void
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
                        completion(.failure(errors))
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
                                completion(.failure(DeleteFactorError.tfaFailed))
                                
                            case .canceled:
                                completion(.failure(DeleteFactorError.tfaCancelled))
                            }
                    },
                        onNoTFA: {
                            completion(.failure(errors))
                    })
                    
                case .success:
                    completion(.success(()))
                }
        })
        
        return cancelable
    }
}

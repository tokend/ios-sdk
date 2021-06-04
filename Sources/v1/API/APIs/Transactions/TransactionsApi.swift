import Foundation

/// Class provides functionality that allows to fetch and send transactions
@available(*, deprecated, message: "Use TransactionsApiV3")
public class TransactionsApi: BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: TransactionsRequestBuilder
    
    // MARK: -
    
    public required init(apiStack: BaseApiStack) {
        self.requestBuilder = TransactionsRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in completion block of `TransactionsApi.requestPayments(...)`
    public enum RequestPaymentsResult {
        
        /// Case of successful response with list of `OperationResponseBase`
        case success(operations: [OperationResponseBase])
        
        /// Case of failed response with `ApiErrors` model
        case failure(ApiErrors)
    }
    
    /// Method sends request to get payments.
    /// The result of request will be fetched in `completion` block as `TransactionsApi.RequestPaymentsResult`
    /// - Parameters:
    ///   - accountId: Identifier of account for which payments should be fetched.
    ///   - parameters: Model of `TransactionsPaymentsRequestParameters` type.
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `TransactionsApi.RequestPaymentsResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestPayments(
        accountId: String,
        parameters: TransactionsPaymentsRequestParameters?,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestPaymentsResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildPaymentsRequest(
            accountId: accountId,
            parameters: parameters,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.network.responseObject(
                    RequestResultPage<OperationsEmbedded>.self,
                    url: request.url,
                    method: request.method,
                    parameters: request.parameters,
                    encoding: request.parametersEncoding,
                    headers: request.signedHeaders,
                    completion: { result in
                        switch result {
                            
                        case .success(let object):
                            completion(.success(operations: object.embedded.records))
                            
                        case .failure(let errors):
                            completion(.failure(errors))
                        }
                })
        })
        
        return cancelable
    }
    
    /// Model that will be fetched in completion block of `TransactionsApi.sendTransaction(...)`
    public enum PaymentSendResult {
        
        /// Case of failed response with `PaymentError` model
        case failure(PaymentError)
        
        /// Case when payment was succesfully sent
        case success(TransactionResponse)
        
        /// Errors that are able to be fetched while trying to send payment
        public enum PaymentError: Swift.Error, LocalizedError {
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
    }
    
    /// Method sends transaction.
    /// The result of request will be fetched in `completion` block as `TransactionsApi.PaymentSendResult`
    /// - Parameters:
    ///   - envelope: Transaction envelope
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `TransactionsApi.PaymentSendResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func sendTransaction(
        envelope: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: PaymentSendResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildSendPaymentRequest(
            envelope: envelope,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.other(.failedToSignRequest)))
                    return
                }
                
                cancelable.cancelable = self?.sendTransaction(
                    request: request,
                    initiateTFA: true,
                    completion: completion
                    )
        })
        
        return cancelable
    }
    
    /// Model that will be fetched in completion block of `TransactionsApi.sendFiatPayment(...)`
    public enum FiatPaymentSendResult {
        
        /// Case of failed response with `PaymentError` model
        case failure(PaymentError)
        
        /// Case when payment was succesfully sent
        case success(FiatPaymentResponse)
        
        /// Errors that are able to be fetched while trying to send payment
        public enum PaymentError: Swift.Error, LocalizedError {
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
    }
    
    /// Method sends fiat payments.
    /// The result of request will be fetched in `completion` block as `TransactionsApi.FiatPaymentSendResult`
    /// - Parameters:
    ///   - envelope: Transaction envelope
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `TransactionsApi.FiatPaymentSendResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func sendFiatPayment(
        envelope: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: FiatPaymentSendResult) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildFiatSendPaymentRequest(
            envelope: envelope,
            sendDate: sendDate,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.other(.failedToSignRequest)))
                    return
                }
                
                cancelable.cancelable = self?.sendFiatPaymentTransaction(
                    request: request,
                    initiateTFA: true,
                    completion: completion
                )
        })
        
        return cancelable
    }
    
    // MARK: - Private
    
    private func sendTransaction(
        request: TransactionsSendPaymentRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: PaymentSendResult) -> Void
        ) -> Cancelable {
        
        let cancellable = self.network.getEmptyCancelable()
        
        cancellable.cancelable = self.network.responseObject(
            TransactionResponse.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            headers: request.signedHeaders,
            completion: { [weak self] result in
                switch result {
                    
                case .success(let response):
                    completion(.success(response))
                    
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
                                cancellable.cancelable = self?.sendTransaction(
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
                }
        })
        
        return cancellable
    }
    
    private func sendFiatPaymentTransaction(
        request: TransactionsSendPaymentRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: FiatPaymentSendResult) -> Void
        ) -> Cancelable {
        
        let cancellable = self.network.getEmptyCancelable()
        
        cancellable.cancelable = self.network.responseObject(
            FiatPaymentResponse.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            headers: request.signedHeaders,
            completion: { [weak self] result in
                switch result {
                    
                case .success(let response):
                    completion(.success(response))
                    
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
                                cancellable.cancelable = self?.sendFiatPaymentTransaction(
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
                }
        })
        
        return cancellable
    }
}

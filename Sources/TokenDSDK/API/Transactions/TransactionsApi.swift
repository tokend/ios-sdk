import Foundation

/// Class provides functionality that allows to fetch and send transactions
public class TransactionsApi: BaseApi {
    let requestBuilder: TransactionsRequestBuilder
    
    public override init(apiStack: BaseApiStack) {
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
    /// - Returns: `CancellableToken`
    @discardableResult
    public func requestPayments(
        accountId: String,
        parameters: TransactionsPaymentsRequestParameters?,
        sendDate: Date = Date(),
        completion: @escaping (_ result: RequestPaymentsResult) -> Void
        ) -> CancellableToken {
        
        let request = self.requestBuilder.buildPaymentsRequest(
            accountId: accountId,
            parameters: parameters,
            sendDate: sendDate
        )
        
        return self.network.responseObject(
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
    }
    
    /// Model that will be fetched in completion block of `TransactionsApi.sendTransaction(...)`
    public enum PaymentSendResult {
        
        /// Case of failed response with `PaymentError` model
        case failure(PaymentError)
        
        /// Case when payment was succesfully sent
        case success
        
        /// Errors that are able to be fetched while trying to send payment
        public enum PaymentError: Swift.Error, LocalizedError {
            case other(ApiErrors)
            case tfaFailed
            
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
    }
    
    /// Method sends request to get payments.
    /// The result of request will be fetched in `completion` block as `TransactionsApi.PaymentSendResult`
    /// - Parameters:
    ///   - envelope: Transaction envelope
    ///   - sendDate: Send time of request.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `TransactionsApi.PaymentSendResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func sendTransaction(
        envelope: String,
        sendDate: Date = Date(),
        completion: @escaping (_ result: PaymentSendResult) -> Void
        ) -> CancellableToken {
        
        let request = self.requestBuilder.buildSendPaymentRequest(
            envelope: envelope,
            sendDate: sendDate
        )
        
        return self.sendTransaction(
            request: request,
            initiateTFA: true,
            completion: completion
        )
    }
    
    // MARK: - Private
    
    private func sendTransaction(
        request: TransactionsSendPaymentRequest,
        initiateTFA: Bool,
        completion: @escaping (_ result: PaymentSendResult) -> Void
        ) -> CancellableToken {
        
        var cancellable: CancellableToken = CancellableToken(request: nil)
        cancellable = self.network.responseJSON(
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            headers: request.signedHeaders,
            completion: { [weak self] result in
                switch result {
                    
                case .success:
                    completion(.success)
                    
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
                                cancellable.request = self?.sendTransaction(
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
                }
        })
        return cancellable
    }
}

import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch and send transactions
public class TransactionsRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to fetch payments
    /// - Parameters:
    ///   - accountId: Identifier of account from which payments should be fetched.
    ///   - parameters: Model of `TransactionsPaymentsRequestParameters` type.
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `TransactionsPaymentsRequest` or nil.
    public func buildPaymentsRequest(
        accountId: String,
        parameters: TransactionsPaymentsRequestParameters?,
        sendDate: Date,
        completion: @escaping (TransactionsPaymentsRequest?) -> Void
        ) {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("accounts").addPath(accountId).addPath("payments")
        
        let parametersEncoding: RequestParametersEncoding = .url
        let parametersDict: RequestParameters = self.requestParametersToDictionary(parameters) ?? [:]
        
        self.buildRequestParametersSigned(
            baseUrl: baseUrl,
            url: url,
            method: .get,
            sendDate: sendDate,
            parameters: parametersDict.isEmpty ? nil : parametersDict,
            parametersEncoding: parametersEncoding,
            completion: completion
        )
    }
    
    /// Builds request to send payments
    /// - Parameters:
    ///   - envelope: Transaction envelope
    ///   - sendDate: Send time of request.
    ///   - completion: Returns `TransactionsSendPaymentRequest` or nil.
    public func buildSendPaymentRequest(
        envelope: String,
        sendDate: Date,
        completion: @escaping (TransactionsSendPaymentRequest?) -> Void
        ) {
        
        let url = self.apiConfiguration.urlString.addPath("transactions")
        let method: RequestMethod = .post
        
        let requestSignModel = RequestSignParametersModel(
            baseUrlString: self.apiConfiguration.urlString,
            urlString: url,
            httpMethod: method
        )
        
        self.requestSigner.sign(
            request: requestSignModel,
            sendDate: sendDate,
            completion: { (signedHeaders) in
                guard let signedHeaders = signedHeaders else {
                    completion(nil)
                    return
                }
                
                let parameters: RequestParameters = [ "tx": envelope ]
                
                let request = TransactionsSendPaymentRequest(
                    url: url,
                    method: method,
                    parameters: parameters,
                    signedHeaders: signedHeaders
                )
                
                completion(request)
        })
    }
}

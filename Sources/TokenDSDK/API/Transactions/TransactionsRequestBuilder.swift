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
    /// - Returns: `TransactionsPaymentsRequest`
    public func buildPaymentsRequest(
        accountId: String,
        parameters: TransactionsPaymentsRequestParameters?,
        sendDate: Date
        ) -> TransactionsPaymentsRequest {
        
        let url = self.apiConfiguration.urlString.addPath("accounts").addPath(accountId).addPath("payments")
        
        let parametersEncoding: RequestParametersEncoding = .urlEncoding
        let parametersDict: RequestParameters = self.requestParametersToDictionary(parameters) ?? [:]
        
        let requestSignModel = RequestSignParametersModel(
            urlString: url,
            parameters: parametersDict,
            parametersEncoding: parametersEncoding
        )
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = TransactionsPaymentsRequest(
            url: url,
            method: .get,
            parameters: parametersDict.isEmpty ? nil : parametersDict,
            parametersEncoding: parametersEncoding,
            signedHeaders: signedHeaders
        )
        
        return request
    }
    
    /// Builds request to send payments
    /// - Parameters:
    ///   - envelope: Transaction envelope
    ///   - sendDate: Send time of request.
    /// - Returns: `TransactionsSendPaymentRequest`
    public func buildSendPaymentRequest(
        envelope: String,
        sendDate: Date
        ) -> TransactionsSendPaymentRequest {
        
        let url = self.apiConfiguration.urlString.addPath("transactions")
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let parameters: RequestParameters = [ "tx": envelope ]
        
        let request = TransactionsSendPaymentRequest(
            url: url,
            method: .post,
            parameters: parameters,
            signedHeaders: signedHeaders
        )
        
        return request
    }
}

import Foundation

public struct TransactionsPaymentsRequest {
    public let url: String
    public let method: RequestMethod
    public let parameters: RequestParameters?
    public let parametersEncoding: RequestParametersEncoding
    public let signedHeaders: RequestHeaders
}

import Foundation

public struct OffersOffersRequest {
    public let url: String
    public let method: RequestMethod
    public let parameters: RequestParameters?
    public let parametersEncoding: RequestParametersEncoding
    public let signedHeaders: RequestHeaders
}

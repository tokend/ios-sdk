import Foundation

@available(*, deprecated)
public struct GetFeeRequest {
    public let url: String
    public let method: RequestMethod
    public let parameters: RequestParameters
    public let parametersEncoding: RequestParametersEncoding
}

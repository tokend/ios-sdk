import Foundation

public struct GetBlobRequest {
    public let url: String
    public let method: RequestMethod
    public let parameters: RequestParameters?
    public let parametersEncoding: RequestParametersEncoding
}

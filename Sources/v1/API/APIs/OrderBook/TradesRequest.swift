import Foundation

public struct TradesRequest {
    
    public let url: String
    public let method: RequestMethod
    public let parameters: RequestParameters?
    public let parametersEncoding: RequestParametersEncoding
    
    public init(
        url: String,
        method: RequestMethod,
        parameters: RequestParameters?,
        parametersEncoding: RequestParametersEncoding
        ) {
        
        self.url = url
        self.method = method
        self.parameters = parameters
        self.parametersEncoding = parametersEncoding
    }
}

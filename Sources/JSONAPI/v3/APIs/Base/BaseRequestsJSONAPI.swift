import Foundation

/// Base model for plain request.
public class RequestModelJSONAPI {
    
    // MARK: - Public properties
    
    public let baseUrl: String
    public let path: String
    public let method: RequestMethod
    public let queryItems: [URLQueryItem]
    public let bodyParameters: RequestBodyParameters?
    public let headers: RequestHeaders?
    
    // MARK: -
    
    public init(
        baseUrl: String,
        path: String,
        method: RequestMethod,
        queryItems: [URLQueryItem] = [],
        bodyParameters: RequestParameters? = nil,
        headers: RequestHeaders? = nil
        ) {
        
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.bodyParameters = bodyParameters
        self.headers = headers
    }
}

extension JSONAPI {
    
    public typealias RequestModel = RequestModelJSONAPI
}

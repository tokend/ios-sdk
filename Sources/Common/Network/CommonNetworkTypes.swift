import Foundation

/// Models of HTTP request methods
public enum RequestMethod: String {
    
    case delete
    case get
    case patch
    case post
    case put
}

/// Encoding types for request parameters
public enum RequestParametersEncoding {
    
    case url
    case json
}

public typealias RequestHeaders = [String: String]

public typealias RequestParameters = [String: Any]

public typealias RequestQueryParameters = [String: String]
public typealias RequestBodyParameters = [String: Any]

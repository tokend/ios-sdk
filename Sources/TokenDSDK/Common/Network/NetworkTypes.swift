import Foundation
import Alamofire

/// Models of HTTP request methods
public enum RequestMethod {
    case delete
    case get
    case patch
    case post
    case put
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .delete:   return .delete
        case .get:      return .get
        case .patch:    return .patch
        case .post:     return .post
        case .put:      return .put
        }
    }
}
/// Encoding types for request parameters
public enum RequestParametersEncoding {
    case urlEncoding
    case jsonEncoding
    
    public var encoding: Alamofire.ParameterEncoding {
        switch self {
        case .urlEncoding:
            return URLEncoding(destination: .queryString, boolEncoding: .literal)
        case .jsonEncoding:
            return JSONEncoding.default
        }
    }
}

public typealias RequestHeaders = [String: String]
public typealias RequestParameters = [String: Any]

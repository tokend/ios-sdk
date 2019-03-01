import Foundation
import Alamofire

extension RequestMethod {
    
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

extension RequestParametersEncoding {
    
    public var encoding: Alamofire.ParameterEncoding {
        switch self {
            
        case .url:
            return URLEncoding(
                destination: .queryString,
                boolEncoding: .literal
            )
            
        case .json:
            return JSONEncoding.default
        }
    }
}

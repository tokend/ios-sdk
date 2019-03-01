import Foundation

/// Network facade helper.
public class NetworkFacade {
    
    // MARK: - Public properties
    
    public let network: NetworkProtocol
    
    // MARK: -
    
    public init(network: NetworkProtocol) {
        self.network = network
    }
    
    // MARK: - Public
    
    public func getEmptyCancelable() -> Cancelable {
        return self.network.getEmptyCancelable()
    }
    
    @discardableResult
    public func responseObject<T: Decodable> (
        _ type: T.Type,
        url: String,
        method: RequestMethod,
        parameters: RequestParameters? = nil,
        encoding: RequestParametersEncoding = .url,
        headers: RequestHeaders? = nil,
        completion: @escaping (_ result: ResponseObjectResult<T>) -> Void
        ) -> Cancelable {
        
        return self.network.responseObject(
            type,
            url: url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers,
            completion: completion
        )
    }
    
    @discardableResult
    public func responseJSON(
        url: String,
        method: RequestMethod,
        parameters: RequestParameters? = nil,
        encoding: RequestParametersEncoding = .url,
        headers: RequestHeaders? = nil,
        completion: @escaping (_ result: ResponseJSONResult) -> Void
        ) -> Cancelable {
        
        return self.network.responseJSON(
            url: url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers,
            completion: completion
        )
    }
    
    @discardableResult
    public func responseDataEmpty(
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseDataEmptyResult) -> Void
        ) -> Cancelable {
        
        return self.network.responseDataEmpty(
            url: url,
            method: method,
            headers: headers,
            bodyData: bodyData,
            completion: completion
        )
    }
    
    @discardableResult
    public func responseRawData(
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseRawDataResult) -> Void
        ) -> Cancelable {
        
        return self.network.responseRawData(
            url: url,
            method: method,
            headers: headers,
            bodyData: bodyData,
            completion: completion
        )
    }
    
    @discardableResult
    public func responseDataObject<T: Decodable>(
        _ type: T.Type,
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseDataObjectResult<T>) -> Void
        ) -> Cancelable {
        
        return self.network.responseDataObject(
            type,
            url: url,
            method: method,
            headers: headers,
            bodyData: bodyData,
            completion: completion
        )
    }
}

import Foundation
import DLJSONAPI

/// Network facade helper.
public class NetworkFacadeJSONAPI {
    
    // MARK: - Public properties
    
    public let network: JSONAPI.NetworkProtocol
    
    // MARK: -
    
    public init(network: JSONAPI.NetworkProtocol) {
        self.network = network
    }
    
    // MARK: - Public
    
    public func getEmptyCancelable() -> Cancelable {
        return self.network.getEmptyCancelable()
    }
    
    public func multiEncodedURLRequest(
        baseUrl: String,
        path: String,
        method: RequestMethod,
        queryItems: [URLQueryItem],
        bodyParameters: RequestParameters?,
        headers: RequestHeaders?
        ) -> URLRequest? {
        
        return self.network.multiEncodedURLRequest(
            baseUrl: baseUrl,
            path: path,
            method: method,
            queryItems: queryItems,
            bodyParameters: bodyParameters,
            headers: headers
        )
    }
    
    public func perform<ResourceType: Resource, DecodableType: Decodable>(
        request: JSONAPI.RequestModel,
        responseType: JSONAPI.ResponseType<ResourceType, DecodableType>,
        onFailed: @escaping (_ error: Error) -> Void
        ) -> Cancelable {
        
        return self.network.perform(
            request: request,
            responseType: responseType,
            onFailed: onFailed
        )
    }
}

extension JSONAPI {
    
    public typealias NetworkFacade = NetworkFacadeJSONAPI
}

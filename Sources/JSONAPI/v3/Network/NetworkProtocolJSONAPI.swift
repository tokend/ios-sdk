import Foundation
import DLJSONAPI

/// Request type options.
public enum ResponseTypeJSONAPI<ResourceType: Resource, DecodableType: Decodable> {
    
    case decodable(onSuccess: (_ decodable: DecodableType) -> Void)
    
    public enum DocumentResponse<DocumentResourceType: Resource> {
        case collection(_ onSuccess: (_ document: Document<[DocumentResourceType]>) -> Void)
        case single(_ onSuccess: (_ document: Document<DocumentResourceType>) -> Void)
    }
    case document(_ response: DocumentResponse<ResourceType>)
    
    public enum RawResponse {
        case empty(_ onSuccess: () -> Void)
        case data(_ onSuccess: (_ data: Data) -> Void)
    }
    case raw(_ response: RawResponse)
}

/// Network access protocol
public protocol JSONAPINetworkProtocol {
    
    /// Method returns empty cancelable placeholder that can be used later.
    /// - Returns: `Cancelable`
    func getEmptyCancelable() -> Cancelable
    
    /// Method to construct url request
    /// - Parameters:
    ///   - baseUrl: Base url.
    ///   - path: Url path.
    ///   - method: HTTP method.
    ///   - queryItems: Query items.
    ///   - bodyParameters: Body params.
    ///   - headers: HTTP headers.
    /// - Returns: `URLRequest` or nil.
    func multiEncodedURLRequest(
        baseUrl: String,
        path: String,
        method: RequestMethod,
        queryItems: [URLQueryItem],
        bodyParameters: RequestBodyParameters?,
        headers: RequestHeaders?
        ) -> URLRequest?
    
    /// Method sends request to api and expects to fetch result according to `RequestType`
    /// - Parameters:
    ///   - url: URL string of request.
    ///   - method: Method of request.
    ///   - queryItems: Array of query items.
    ///   - bodyParameters: Body parameters.
    ///   - headers: Headers of request.
    ///   - requestType: Request type with success compeltion block.
    ///   - onFailed: Error completion block.
    ///   - error: Error model.
    /// - Returns: `Cancelable`
    @discardableResult
    func perform<ResourceType: Resource, DecodableType: Decodable>(
        request: JSONAPI.RequestModel,
        responseType: JSONAPI.ResponseType<ResourceType, DecodableType>,
        onFailed: @escaping (_ error: Error) -> Void
        ) -> Cancelable
}

extension JSONAPI {
    
    public typealias NetworkProtocol = JSONAPINetworkProtocol
    public typealias ResponseType = ResponseTypeJSONAPI
}

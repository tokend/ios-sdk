import Foundation
import DLJSONAPI
import Alamofire
import AlamofireNetworkActivityLogger

/// Class implements sending requests to api and getting responses
public class AlamofireNetworkJSONAPI {
    
    // MARK: - Public properties
    
    public let userAgent: String?
    public let onUnathorizedRequest: (_ error: Error) -> Void
    public let resourcePool: ResourcePool
    
    /// Log detail level for NetworkActivityLogger.
    /// Default is `debug`.
    public var loggerLevel: NetworkActivityLoggerLevel {
        get { return NetworkActivityLogger.shared.level }
        set { NetworkActivityLogger.shared.level = newValue }
    }
    
    public let sessionManager: SessionManager
    
    public var jsonDecoder: JSONDecoder = JSONDecoder()
    
    // MARK: -
    
    public init(
        resourcePool: ResourcePool,
        userAgent: String? = nil,
        onUnathorizedRequest: @escaping (_ error: Error) -> Void
        ) {
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = "application/vnd.api+json"
        headers["Accept"] = "application/vnd.api+json"
        if let userAgent = userAgent {
            headers["User-Agent"] = userAgent
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        self.resourcePool = resourcePool
        self.userAgent = userAgent
        self.onUnathorizedRequest = onUnathorizedRequest
        self.loggerLevel = .debug
    }
    
    // MARK: - Public
    
    public func startLogger() {
        NetworkActivityLogger.shared.startLogging()
    }
    
    public func stopLogger() {
        NetworkActivityLogger.shared.stopLogging()
    }
    
    // MARK: -
    
    private func checkForResponseTypeError(
        resultError: Error,
        dataResponse: DataResponse<Data>,
        data: Data
        ) -> Error {
        
        let requestError: Error
        
        if let afError = resultError as? AFError {
            switch afError {
                
            case .responseValidationFailed(let reason):
                switch reason {
                    
                case .unacceptableContentType(_, let responseContentType):
                    if responseContentType == "text/plain",
                        let responseString = String(data: data, encoding: .utf8) {
                        
                        requestError = NSError(
                            domain: "com.tokend.sdk.ios",
                            code: dataResponse.response?.statusCode ?? 0,
                            userInfo: [
                                NSLocalizedDescriptionKey: responseString
                            ]
                        )
                    } else {
                        requestError = resultError
                    }
                    
                default:
                    requestError = resultError
                }
                
            default:
                requestError = resultError
            }
        } else {
            requestError = resultError
        }
        
        return requestError
    }
}

// MARK: - JSONAPI.AlamofireNetwork

extension JSONAPI {
    
    public typealias AlamofireNetwork = AlamofireNetworkJSONAPI
}

// MARK: - JSONAPI.NetworkProtocol

extension JSONAPI.AlamofireNetwork: JSONAPI.NetworkProtocol {
    
    public func getEmptyCancelable() -> Cancelable {
        return AlamofireCancelable(request: nil)
    }
    
    public func multiEncodedURLRequest(
        baseUrl: String,
        path: String,
        method: RequestMethod,
        queryItems: [URLQueryItem],
        bodyParameters: RequestParameters?,
        headers: RequestHeaders?
        ) -> URLRequest? {
        
        let urlString = baseUrl/path
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        let temporaryRequest = URLRequest(url: url)
        
        var queryParameters: [String: Any] = [:]
        
        queryItems.forEach({ (item) in
            let snakeCased = item.name.snakeCased() ?? item.name
            queryParameters[snakeCased] = item.value ?? ""
        })
        
        guard let urlEncoded = try? URLEncoding.default.encode(
            temporaryRequest,
            with: queryParameters
            ) else {
                return nil
        }
        
        guard let bodyEncoded = try? JSONEncoding.default.encode(
            temporaryRequest,
            with: bodyParameters
            ) else {
                return nil
        }
        
        var compositeRequest = urlEncoded.urlRequest
        
        compositeRequest?.httpMethod = method.method.rawValue
        compositeRequest?.httpBody = bodyEncoded.httpBody
        
        headers?.forEach({ (header) in
            compositeRequest?.addValue(header.value, forHTTPHeaderField: header.key)
        })
        
        return compositeRequest!
    }
    
    @discardableResult
    public func perform<ResourceType: Resource, DecodableType: Decodable>(
        request: JSONAPI.RequestModel,
        responseType: JSONAPI.ResponseType<ResourceType, DecodableType>,
        onFailed: @escaping (_ error: Error) -> Void
        ) -> Cancelable {
        
        guard let request = self.multiEncodedURLRequest(
            baseUrl: request.baseUrl,
            path: request.path,
            method: request.method,
            queryItems: request.queryItems,
            bodyParameters: request.bodyParameters,
            headers: request.headers
            ) else {
                let error = ErrorObject(dictionary: [
                    "status": ErrorCodes.urlEncodeFailed.stringValue,
                    "title": ErrorCodes.urlEncodeFailed.errorDescription
                    ]
                )
                onFailed(error)
                return self.getEmptyCancelable()
        }
        
        let cancelable = self.sessionManager
            .request(request)
            .validate(contentType: ["application/vnd.api+json"])
            .responseData { (dataResponse) in
                let data = dataResponse.data
                
                switch dataResponse.result {
                    
                case .failure(let resultError):
                    let requestError: Error
                    
                    // attempt to parse JSONAPIError
                    if let data = data {
                        do {
                            let _: Document<EmptyResource> = try JSONAPIDecoder.decode(
                                data: data,
                                resourcePool: self.resourcePool
                            )
                            requestError = resultError
                        } catch let deserializeError as JSONAPIError {
                            requestError = deserializeError
                        } catch {
                            requestError = self.checkForResponseTypeError(
                                resultError: resultError,
                                dataResponse: dataResponse,
                                data: data
                            )
                        }
                    } else {
                        requestError = resultError
                    }
                    
                    onFailed(requestError)
                    
                case .success(let value):
                    switch responseType {
                        
                    case .decodable(let onSuccess):
                        do {
                            let decodable = try self.jsonDecoder.decode(DecodableType.self, from: value)
                            onSuccess(decodable)
                        } catch let deserializeError {
                            onFailed(deserializeError)
                        }
                        
                    case .document(let request):
                        switch request {
                            
                        case .collection(let onSuccess):
                            do {
                                let document = try Deserializer.Collection<ResourceType>(
                                    resourcePool: self.resourcePool
                                    ).deserialize(data: value)
                                onSuccess(document)
                            } catch let deserializeError {
                                onFailed(deserializeError)
                            }
                            
                        case .single(let onSuccess):
                            do {
                                let document = try Deserializer.Single<ResourceType>(
                                    resourcePool: self.resourcePool
                                    ).deserialize(data: value)
                                onSuccess(document)
                            } catch let deserializeError {
                                onFailed(deserializeError)
                            }
                        }
                        
                    case .raw(let request):
                        switch request {
                            
                        case .data(let onSuccess):
                            onSuccess(value)
                            
                        case .empty(let onSuccess):
                            onSuccess()
                        }
                    }
                }
        }
        
        return AlamofireCancelable(request: cancelable)
    }
}

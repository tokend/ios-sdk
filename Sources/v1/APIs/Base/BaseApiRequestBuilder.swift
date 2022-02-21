import Foundation

/// Base api request builder stack.
public struct BaseApiRequestBuilderStack {
    
    // MARK: - Public properties
    
    public var apiConfiguration: ApiConfiguration {
        apiConfigurationProvider.apiConfiguration
    }
    public let apiConfigurationProvider: ApiConfigurationProviderProtocol
    public let requestSigner: RequestSignerProtocol
    
    // MARK: -
    
    public init(
        apiConfigurationProvider: ApiConfigurationProviderProtocol,
        requestSigner: RequestSignerProtocol
        ) {
        
        self.apiConfigurationProvider = apiConfigurationProvider
        self.requestSigner = requestSigner
    }
    
    // MARK: - Public
    
    public static func fromApiStack(_ apiStack: BaseApiStack) -> BaseApiRequestBuilderStack {
        return BaseApiRequestBuilderStack(
            apiConfigurationProvider: apiStack.apiConfigurationProvider,
            requestSigner: apiStack.requestSigner
        )
    }
}

/// Parent for other request builder classes.
public class BaseApiRequestBuilder {
    
    public var apiConfiguration: ApiConfiguration {
        apiConfigurationProvider.apiConfiguration
    }
    public var apiConfigurationProvider: ApiConfigurationProviderProtocol
    public let requestSigner: RequestSignerProtocol
    
    // MARK: -
    
    public init(builderStack: BaseApiRequestBuilderStack) {
        self.apiConfigurationProvider = builderStack.apiConfigurationProvider
        self.requestSigner = builderStack.requestSigner
    }
    
    /// Method transforms request parameters to dicitionary
    /// - Parameters:
    ///   - parameters: Parameters to be trasformed
    /// - Returns: `RequestParameters`
    public func requestParametersToDictionary<ParametersType: Encodable>(
        _ parameters: ParametersType?
        ) -> RequestParameters? {
        
        guard let parameters = parameters,
            let data = try? JSONCoders.snakeCaseEncoder.encode(parameters),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? RequestParameters
            else {
                return nil
        }
        return dictionary
    }
    
    /// Method builds request with signed headers
    /// - Parameters:
    ///   - url: Request URL string.
    ///   - method: HTTP method.
    ///   - sendDate: Send date.
    ///   - completion: Returns `RequestSigned` or nil.
    public func buildRequestSigned(
        baseUrl: String,
        url: String,
        method: RequestMethod,
        sendDate: Date,
        completion: @escaping (RequestSigned?) -> Void
        ) {
        
        let requestSignModel = RequestSignParametersModel(
            baseUrlString: baseUrl,
            urlString: url,
            httpMethod: method
        )
        self.requestSigner.sign(
            request: requestSignModel,
            sendDate: sendDate,
            completion: { (signedHeaders) in
                guard let signedHeaders = signedHeaders else {
                    completion(nil)
                    return
                }
                
                let request = RequestSigned(
                    url: url,
                    method: method,
                    signedHeaders: signedHeaders
                )
                completion(request)
        })
    }
    
    /// Method builds request with signed headers
    /// - Parameters:
    ///   - url: Request URL string.
    ///   - method: HTTP method.
    ///   - sendDate: Send date.
    ///   - parameters: Request parameters.
    ///   - parametersEncoding: Request parameters encoding.
    ///   - completion: Returns `RequestParametersSigned` or nil.
    public func buildRequestParametersSigned(
        baseUrl: String,
        url: String,
        method: RequestMethod,
        sendDate: Date,
        parameters: RequestParameters?,
        parametersEncoding: RequestParametersEncoding,
        completion: @escaping (RequestParametersSigned?) -> Void
        ) {
        
        let requestSignModel = RequestSignParametersModel(
            baseUrlString: baseUrl,
            urlString: url,
            httpMethod: method,
            parameters: parameters,
            parametersEncoding: parametersEncoding
        )
        self.requestSigner.sign(
            request: requestSignModel,
            sendDate: sendDate,
            completion: { (signedHeaders) in
                guard let signedHeaders = signedHeaders else {
                    completion(nil)
                    return
                }
                
                let request = RequestParametersSigned(
                    url: url,
                    method: method,
                    parameters: (parameters?.isEmpty ?? true) ? nil : parameters,
                    parametersEncoding: parametersEncoding,
                    signedHeaders: signedHeaders
                )
                completion(request)
        })
    }
    
    /// Method builds request with signed headers
    /// - Parameters:
    ///   - url: Request URL string.
    ///   - method: HTTP method.
    ///   - requestData: Request raw data.
    ///   - sendDate: Send date.
    ///   - completion: Returns `RequestSigned` or nil.
    public func buildRequestDataSigned(
        baseUrl: String,
        url: String,
        method: RequestMethod,
        requestData: Data,
        sendDate: Date,
        completion: @escaping (RequestDataSigned?) -> Void
        ) {
        
        let requestSignModel = RequestSignParametersModel(
            baseUrlString: baseUrl,
            urlString: url,
            httpMethod: method
        )
        self.requestSigner.sign(
            request: requestSignModel,
            sendDate: sendDate,
            completion: { (signedHeaders) in
                guard let signedHeaders = signedHeaders else {
                    completion(nil)
                    return
                }
                
                let request = RequestDataSigned(
                    url: url,
                    method: method,
                    requestData: requestData,
                    signedHeaders: signedHeaders
                )
                completion(request)
        })
    }
}

extension ApiErrors {
    
    /// Default error for failed request sign.
    public static var failedToSignRequest: ApiErrors {
        return ApiErrors(errors: [
            ApiError(
                status: ApiError.Status.requestSignFailed,
                code: nil,
                title: ApiError.Title.requestSignFailed,
                detail: nil
            )
            ]
        )
    }
}

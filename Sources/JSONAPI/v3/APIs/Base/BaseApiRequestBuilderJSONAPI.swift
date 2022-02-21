import Foundation
import DLJSONAPI

/// Base api request builder stack.
public struct BaseApiRequestBuilderStackJSONAPI {
    
    // MARK: - Public properties
    
    public var apiConfiguration: ApiConfiguration {
        apiConfigurationProvider.apiConfiguration
    }
    public let apiConfigurationProvider: ApiConfigurationProviderProtocol
    public let requestSigner: JSONAPI.RequestSignerProtocol
    public let network: JSONAPI.NetworkProtocol
    
    // MARK: -
    
    public init(
        apiConfigurationProvider: ApiConfigurationProviderProtocol,
        requestSigner: JSONAPI.RequestSignerProtocol,
        network: JSONAPI.NetworkProtocol
        ) {
        
        self.apiConfigurationProvider = apiConfigurationProvider
        self.requestSigner = requestSigner
        self.network = network
    }
    
    // MARK: - Public
    
    public static func fromApiStack(_ apiStack: JSONAPI.BaseApiStack) -> JSONAPI.BaseApiRequestBuilderStack {
        return JSONAPI.BaseApiRequestBuilderStack(
            apiConfigurationProvider: apiStack.apiConfigurationProvider,
            requestSigner: apiStack.requestSigner,
            network: apiStack.network
        )
    }
}

/// Parent for other request builder classes.
public class BaseApiRequestBuilderJSONAPI {
    
    // MARK: - Public properties
    
    public var apiConfiguration: ApiConfiguration { apiConfigurationProvider.apiConfiguration }
    public let apiConfigurationProvider: ApiConfigurationProviderProtocol
    public let requestSigner: JSONAPI.RequestSignerProtocol
    public let network: JSONAPI.NetworkProtocol
    
    public let v3: String = "v3"
    
    // MARK: -
    
    public init(builderStack: JSONAPI.BaseApiRequestBuilderStack) {
        self.apiConfigurationProvider = builderStack.apiConfigurationProvider
        self.requestSigner = builderStack.requestSigner
        self.network = builderStack.network
    }
    
    // MARK: - Public
    
    func getBaseUrlString() -> String {
        let baseUrl = self.apiConfiguration.urlString
        
        return baseUrl
    }
    
    /// Method builds request model.
    /// - Parameters:
    ///   - buildModel: Request build model.
    /// - Returns: `RequestModel`.
    public func buildRequest(
        _ buildModel: JSONAPI.BaseRequestBuildModel
        ) -> JSONAPI.RequestModel {
        
        var queryItems: [URLQueryItem] = []
        
        if let queryParameters = buildModel.queryParameters {
            queryItems.append(contentsOf: queryParameters.toQueryItems())
        }
        
        if let include = buildModel.include, let includeQueryItem = self.buildIncludeQueryItem(include) {
            queryItems.append(includeQueryItem)
        }
        
        if let pagination = buildModel.pagination {
            queryItems.append(contentsOf: pagination.getQueryItems())
        }
        
        let unsignedRequest = JSONAPI.RequestModel(
            baseUrl: self.getBaseUrlString(),
            path: buildModel.path,
            method: buildModel.method,
            queryItems: queryItems,
            bodyParameters: buildModel.bodyParameters,
            headers: buildModel.headers
        )
        
        return unsignedRequest
    }
    
    /// Method builds request model.
    /// - Parameters:
    ///   - buildModel: Request build model.
    ///   - shouldSign: Indicates whether is sing required.
    ///   - completion: Completion block with `RequestModel` or nil.
    public func buildRequest(
        _ buildModel: JSONAPI.BaseRequestBuildModel,
        shouldSign: Bool,
        sendDate: Date,
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let unsignedRequest = self.buildRequest(buildModel)
        
        if shouldSign {
            let requestSignModel = JSONAPI.RequestSignParametersModel(
                baseUrl: unsignedRequest.baseUrl,
                path: unsignedRequest.path,
                method: unsignedRequest.method,
                queryItems: unsignedRequest.queryItems,
                bodyParameters: unsignedRequest.bodyParameters,
                headers: unsignedRequest.headers,
                sendDate: sendDate,
                network: self.network
            )
            
            self.requestSigner.sign(
                request: requestSignModel,
                completion: { (signedHeaders) in
                    guard let signedHeaders = signedHeaders else {
                        completion(nil)
                        return
                    }
                    
                    let request = JSONAPI.RequestModel(
                        baseUrl: requestSignModel.baseUrl,
                        path: requestSignModel.path,
                        method: requestSignModel.method,
                        queryItems: requestSignModel.queryItems,
                        bodyParameters: requestSignModel.bodyParameters,
                        headers: signedHeaders
                    )
                    completion(request)
            })
        } else {
            completion(unsignedRequest)
        }
    }
    
    /// Builds query item for given include keys
    public func buildIncludeQueryItem(_ include: [String]) -> URLQueryItem? {
        guard include.count > 0 else {
            return nil
        }
        
        let value = include.joined(separator: ",")
        
        return URLQueryItem(
            name: "include",
            value: value
        )
    }
    
    public func buildFilterQueryItems(
        filterKey: String = "filter",
        _ filters: [String: String]
        ) -> RequestQueryParameters {
        
        let keyValues = filters.map({ (key, value) -> (key: String, value: String) in
            return (key: "\(filterKey)[\(key)]", value: value)
        })
        
        return RequestQueryParameters(
            keyValues,
            uniquingKeysWith: { (key1, _) -> String in
                return key1
        })
    }
}

extension JSONAPI {
    
    public typealias BaseApiRequestBuilderStack = BaseApiRequestBuilderStackJSONAPI
    public typealias BaseApiRequestBuilder = BaseApiRequestBuilderJSONAPI
}

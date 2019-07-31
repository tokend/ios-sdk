import Foundation
import DLJSONAPI

/// Base api stack model.
public struct BaseApiStackJSONAPI {
    
    public let apiConfiguration: ApiConfiguration
    public let callbacks: JSONAPI.ApiCallbacks
    public let network: JSONAPI.NetworkProtocol
    public let requestSigner: JSONAPI.RequestSignerProtocol
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        callbacks: JSONAPI.ApiCallbacks,
        network: JSONAPI.NetworkProtocol,
        requestSigner: JSONAPI.RequestSignerProtocol
        ) {
        
        self.apiConfiguration = apiConfiguration
        self.callbacks = callbacks
        self.network = network
        self.requestSigner = requestSigner
    }
}

/// Parent for other api classes.
public class BaseApiJSONAPI {
    
    public let apiConfiguration: ApiConfiguration
    public let baseRequestBuilder: JSONAPI.BaseApiRequestBuilder
    public let network: JSONAPI.NetworkFacade
    public let requestSigner: JSONAPI.RequestSignerProtocol
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.apiConfiguration = apiStack.apiConfiguration
        self.baseRequestBuilder = JSONAPI.BaseApiRequestBuilder(
            builderStack: JSONAPI.BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        self.network = JSONAPI.NetworkFacade(network: apiStack.network)
        self.requestSigner = apiStack.requestSigner
    }
    
    // MARK: - Public
    
    @discardableResult
    public func requestEmpty(
        request: JSONAPI.RequestModel,
        completion: @escaping (_ result: RequestEmptyResult) -> Void
        ) -> Cancelable {
        
        return self.network.perform(
            request: request,
            responseType: JSONAPI.ResponseType<EmptyResource, Empty>.raw(
                .empty({
                    completion(.success)
                })
            ),
            onFailed: { (error) in
                completion(.failure(error))
        })
    }
    
    @discardableResult
    public func requestSingle<ResourceType: Resource>(
        _ resource: ResourceType.Type,
        request: JSONAPI.RequestModel,
        completion: @escaping (_ result: RequestSingleResult<ResourceType>) -> Void
        ) -> Cancelable {
        
        return self.network.perform(
            request: request,
            responseType: JSONAPI.ResponseType<ResourceType, Empty>.document(.single({ (document) in
                completion(.success(document))
            })),
            onFailed: { (error) in
                completion(.failure(error))
        })
    }
    
    @discardableResult
    public func requestCollection<ResourceType: Resource>(
        _ resource: ResourceType.Type,
        request: JSONAPI.RequestModel,
        completion: @escaping (_ result: RequestCollectionResult<ResourceType>) -> Void
        ) -> Cancelable {
        
        return self.network.perform(
            request: request,
            responseType: JSONAPI.ResponseType<ResourceType, Empty>.document(.collection({ (document) in
                completion(.success(document))
            })),
            onFailed: { (error) in
                completion(.failure(error))
        })
    }
}

extension JSONAPI {
    
    public typealias BaseApi = BaseApiJSONAPI
    public typealias BaseApiStack = BaseApiStackJSONAPI
}

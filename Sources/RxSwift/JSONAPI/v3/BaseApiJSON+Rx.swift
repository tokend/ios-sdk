import Foundation
import DLJSONAPI
import RxSwift

extension BaseApiJSONAPI: ReactiveCompatible {}

extension Reactive where Base: BaseApiJSONAPI {
    
    public func requestSingle<ResourceType: Resource>(
        _ resource: ResourceType.Type,
        request: JSONAPI.RequestModel
        ) -> Single<Document<ResourceType>> {
        
        return Single<Document<ResourceType>>.create(subscribe: { (event) in
            let cancelable = self.base.network.perform(
                request: request,
                responseType: JSONAPI.ResponseType<ResourceType, Empty>.document(.single({ (document) in
                    event(.success(document))
                })),
                onFailed: { (error) in
                    event(.failure(error))
            })
            
            return Disposables.create {
                cancelable.cancel()
            }
        })
    }
    
    public func requestCollection<ResourceType: Resource>(
        _ resource: ResourceType.Type,
        request: JSONAPI.RequestModel
        ) -> Single<Document<[ResourceType]>> {
        
        return Single<Document<[ResourceType]>>.create(subscribe: { (event) in
            let cancelable = self.base.network.perform(
                request: request,
                responseType: JSONAPI.ResponseType<ResourceType, Empty>.document(.collection({ (document) in
                    event(.success(document))
                })),
                onFailed: { (error) in
                    event(.failure(error))
            })
            
            return Disposables.create {
                cancelable.cancel()
            }
        })
    }
    
    public func loadPageForLinks<ResourceType: Resource>(
        _ resource: ResourceType.Type,
        links: Links,
        page: JSONAPI.LinksPage,
        previousRequest: JSONAPI.RequestModel,
        bodyParameters: RequestBodyParameters? = nil,
        headers: RequestHeaders? = nil,
        shouldSign: Bool,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil
        ) -> Single<Document<[ResourceType]>> {
        
        return Single<Document<[ResourceType]>>.create(subscribe: { (event) in
            let cancelable = self.base.loadPageForLinks(
                resource,
                links: links,
                page: page,
                previousRequest: previousRequest,
                bodyParameters: bodyParameters,
                shouldSign: shouldSign,
                onRequestBuilt: onRequestBuilt,
                completion: { (result) in
                    switch result {
                        
                    case .failure(let error):
                        event(.failure(error))
                        
                    case .success(let document):
                        event(.success(document))
                    }
            })
            
            return Disposables.create {
                cancelable.cancel()
            }
        })
    }
}

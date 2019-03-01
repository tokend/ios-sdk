import Foundation
import DLJSONAPI

extension BaseApiJSONAPI {
    
    @discardableResult
    public func loadPageForLinks<ResourceType: Resource>(
        _ resource: ResourceType.Type,
        links: Links,
        page: JSONAPI.LinksPage,
        previousRequest: JSONAPI.RequestModel,
        bodyParameters: RequestBodyParameters? = nil,
        headers: RequestHeaders? = nil,
        shouldSign: Bool,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping (_ result: RequestCollectionResult<ResourceType>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        let performRequest: (_ request: JSONAPI.RequestModel?) -> Void = { [weak self] (request) in
            guard let request = request else {
                completion(.failure(JSONAPIError.failedToBuildRequest))
                return
            }
            
            onRequestBuilt?(request)
            
            cancelable.cancelable = self?.requestCollection(
                resource,
                request: request,
                completion: completion
            )
        }
        
        self.baseRequestBuilder.buildRequestFromLinks(
            links,
            page: page,
            method: previousRequest.method,
            bodyParameters: bodyParameters,
            headers: headers,
            shouldSign: shouldSign,
            completion: performRequest
        )
        
        return cancelable
    }
}

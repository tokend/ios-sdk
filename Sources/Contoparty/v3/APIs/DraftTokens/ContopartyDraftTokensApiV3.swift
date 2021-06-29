import Foundation
import DLJSONAPI

public extension Contoparty {
    
    class DraftTokensApiV3: JSONAPI.BaseApi {
        
        // MARK: - Public properties
        
        public let requestBuilder: DraftTokensRequestBuilderV3
        
        // MARK: -
        
        public required init(apiStack: JSONAPI.BaseApiStack) {
            self.requestBuilder = .init(
                builderStack: .fromApiStack(apiStack)
            )
            
            super.init(apiStack: apiStack)
        }
    }
}

// MARK: - Public methods

public extension Contoparty.DraftTokensApiV3 {
    
    @discardableResult
    func getListOfDraftTokens(
        filters: Contoparty.DraftTokensRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<Contoparty.DraftTokenResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetListOfDraftTokens(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    Contoparty.DraftTokenResource.self,
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
}

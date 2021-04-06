import Foundation
import DLJSONAPI

public extension DMS {
    
    class ProjectsApiV3: JSONAPI.BaseApi {
        
        // MARK: - Public properties
        
        public let requestBuilder: ProjectsRequestBuilderV3
        
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

public extension DMS.ProjectsApiV3 {
    
    @discardableResult
    func getListOfProjects(
        filters: ProjectsRequestFiltersV3,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<DMS.ProjectsResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetListOfProjects(
            filters: filters,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    DMS.ProjectsResource.self,
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

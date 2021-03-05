import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch tutorials' data
public class TutorialsApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties

    public let requestBuilder: TutorialsRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = TutorialsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public

    /// Method sends request to fetch list of tutorials from api.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestCollectionResult<MunaTutorials.VideoResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getListTutorials(
        filters: TutorialsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<MunaTutorials.VideoResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildListVideosRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    MunaTutorials.VideoResource.self,
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .success(let document):
                            completion(.success(document))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
}

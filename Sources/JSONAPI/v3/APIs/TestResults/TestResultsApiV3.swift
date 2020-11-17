import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch test results' data
public class TestResultsApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties

    public let requestBuilder: TestResultsRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = TestResultsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to fetch test results from api.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestCollectionResult<TestResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getTestResults(
        filters: TestResultsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<MunaTestResults.TestResource>) -> Void)
    ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildTestResultsRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    MunaTestResults.TestResource.self,
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

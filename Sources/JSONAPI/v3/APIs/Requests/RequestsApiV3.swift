import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch reviewable requests data
public class RequestsApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: RequestsRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = RequestsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Returns the list of the reviewable requests.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<ReviewableRequestResource>`.
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestRequests(
        filters: RequestsFiltersV3,
        include: [String]? = nil,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping (_ result: RequestCollectionResult<ReviewableRequestResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildRequestsRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                onRequestBuilt?(request)
                
                cancelable.cancelable = self?.requestCollection(
                    ReviewableRequestResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
}

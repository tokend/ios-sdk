import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch atomic swap data
public class AtomicSwapApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: AtomicSwapRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = AtomicSwapRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Returns the list of the atomic swap asks.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<AtomicSwapAskResource>`.
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAtomicSwapAsks(
        filters: AtomicSwapFiltersV3,
        include: [String]? = nil,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping (_ result: RequestCollectionResult<AtomicSwapAskResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildAtomicSwapAsksRequest(
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
                    AtomicSwapAskResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
}

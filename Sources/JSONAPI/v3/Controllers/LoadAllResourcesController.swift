import Foundation
import DLJSONAPI

/// Controller to load all available resources.
public class LoadAllResourcesController <ResourceType: Resource> {
    
    public typealias LoadPageCompletionBlock = (_ result: PageResult) -> Void
    
    public typealias LoadPageBlock = (
        _ pagination: RequestPagination,
        _ completion: @escaping  LoadPageCompletionBlock
        ) -> Void
    
    public typealias LoadCompletionBlock = (
        _ result: Result,
        _ data: [ResourceType]
        ) -> Void
    
    // MARK: - Public properties
    
    public private(set) var data: [ResourceType] = []
    public private(set) var error: Error?
    
    // MARK: - Private properties
    
    private let requestPagination: RequestPagination
    
    // MARK: -
    
    public init(
        requestPagination: RequestPagination
        ) {
        
        self.requestPagination = requestPagination
    }
    
    // MARK: - Public
    
    public func loadResources(
        loadPage: @escaping LoadPageBlock,
        completion: @escaping  LoadCompletionBlock
        ) {
        
        self.requestPagination.resetToFirstPage()
        
        loadPage(self.requestPagination, { [weak self] (result) in
            guard let sSelf = self else { return }
            
            switch result {
                
            case .failed(let error):
                sSelf.error = error
                sSelf.completed(completion: completion)
                
            case .succeeded(let data):
                sSelf.data = data
                
                if sSelf.requestPagination.hasNextPage(resultsCount: data.count) {
                    sSelf.loadResourcesPage(
                        loadPage: loadPage,
                        completion: completion
                    )
                } else {
                    sSelf.completed(completion: completion)
                }
            }
        })
    }
    
    // MARK: - Private
    
    private func loadResourcesPage(
        loadPage: @escaping LoadPageBlock,
        completion: @escaping LoadCompletionBlock
        ) {
        
        loadPage(self.requestPagination, { [weak self] (result) in
            guard let sSelf = self else { return }
            
            switch result {
                
            case .failed(let error):
                sSelf.error = error
                sSelf.completed(completion: completion)
                
            case .succeeded(let data):
                sSelf.data.appendUniques(contentsOf: data)
                
                if sSelf.requestPagination.hasNextPage(resultsCount: data.count) {
                    sSelf.loadResourcesPage(
                        loadPage: loadPage,
                        completion: completion
                    )
                } else {
                    sSelf.completed(completion: completion)
                }
            }
        })
    }
    
    private func completed(completion: LoadCompletionBlock) {
        if let error = self.error {
            completion(.failed(error), self.data)
        } else {
            completion(.succeded, self.data)
        }
    }
}

extension LoadAllResourcesController {
    
    public enum Result {
        
        case failed(Error)
        case succeded
    }
    
    public enum PageResult {
        
        case failed(Error)
        case succeeded([ResourceType])
    }
}

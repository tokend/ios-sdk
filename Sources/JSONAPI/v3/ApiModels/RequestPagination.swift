import Foundation
import DLJSONAPI

/// Controller object for pagination management logic.
public class RequestPagination {
    
    // MARK: - Public properties
    
    /// Pagination option.
    public private(set) var option: Option
    
    // MARK: -
    
    public init(_ option: Option) {
        self.option = option
    }
    
    // MARK: - Public
    
    public func getQueryItems() -> [URLQueryItem] {
        let urlQueryItems: [URLQueryItem]
        
        switch self.option {
            
        case .single(let index, let limit, let order):
            let page = IndexedPageModel(index: index, limit: limit, order: order)
            urlQueryItems = page.urlQueryItems()
            
        case .strategy(let strategy):
            let page: IndexedPageModel
            if let nextPage = strategy.nextPage {
                page = nextPage
            } else {
                page = strategy.firstPage
            }
            urlQueryItems = page.urlQueryItems()
        }
        
        return urlQueryItems
    }
    
    /// Points on current loaded page.
    public var currentPointerIndex: Int {
        switch self.option {
        case .single(let index, _, _): return index
        case .strategy(let strategy): return strategy.currentPage?.index ?? strategy.firstPage.index
        }
    }
    
    /// Resets pagination strategy pointer.
    /// Note: Only applied to `strategy` option.
    public func resetToFirstPage() {
        switch self.option {
            
        case .strategy(let strategy):
            _ = strategy.toStartPage()
            
        default:
            return
        }
    }
    
    /// Checks whether is next page available to request based on `resultsCount` of previous response.
    /// - Parameters:
    ///   - resultsCount: Results count of previous response.
    /// - Returns: `bool` indicating whether next page available or not.
    public func hasNextPage(resultsCount: Int = .max) -> Bool {
        switch self.option {
            
        case .single:
            return false
            
        case .strategy(let strategy):
            return strategy.nextPage != nil
        }
    }
    
    /// Adjusts option value based on provided data.
    /// - Parameters:
    ///   - resultsCount: Results count of previous response.
    ///   - links: `Links` model from previous response `Document`.
    public func adjustPagination(
        resultsCount: Int,
        links: Links?
        ) {
        
        let adjustedOption: Option
        switch self.option {
            
        case .single:
            adjustedOption = self.option
            
        case.strategy(let strategy):
            let isLastPage = resultsCount < strategy.limit
            
            if let links = links, let updated = IndexedPaginationStrategy(links: links) {
                strategy.currentPage = updated.currentPage
                strategy.lastPage = updated.lastPage
            } else {
                if strategy.currentPage != nil {
                    _ = strategy.toNextPage()
                } else {
                    strategy.currentPage = strategy.firstPage
                }
            }
            
            if isLastPage {
                strategy.lastPageReached()
            }
            
            adjustedOption = .strategy(strategy)
        }
        self.option = adjustedOption
    }
}

extension RequestPagination {
    
    /// Request pagination options.
    public enum Option {
        
        /// Option for single page request.
        case single(index: Int, limit: Int, order: PaginationOrder)
        
        /// Option with strategy provided.
        /// Strategy reference should be updated in `request...` func according to response.
        case strategy(_ strategy: IndexedPaginationStrategy)
    }
}

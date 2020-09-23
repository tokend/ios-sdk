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
            
        case .single(let index, let limit, let order),
             .indexedSingle(let index, let limit, let order):
            let page = IndexedPageModel(index: index, limit: limit, order: order)
            urlQueryItems = page.urlQueryItems()

        case .cursorSingle(let cursor, let limit, let order):
            let page = CursorPageModel(cursor: cursor, limit: limit, order: order)
            urlQueryItems = page.urlQueryItems()
            
        case .strategy(let strategy),
             .indexedStrategy(let strategy):
            let page: IndexedPageModel
            if let nextPage = strategy.nextPage {
                page = nextPage
            } else {
                page = strategy.firstPage
            }
            urlQueryItems = page.urlQueryItems()

        case .cursorStrategy(let strategy):
            let page: CursorPageModel
            if let nextPage = strategy.nextPage {
                page = nextPage
            } else {
                page = strategy.firstPage
            }
            urlQueryItems = page.urlQueryItems()
        }
        
        return urlQueryItems
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

        return !isLastPage(resultsCount: resultsCount)
    }

    /// Checks wheter current page is last page based on `resultsCount` of previous response.
    /// - Parameters:
    ///   - resultsCount: Results count of previous response.
    /// - Returns: `bool` indicating whether current page is last page available.
    public func isLastPage(resultsCount: Int = .max) -> Bool {
        switch self.option {

        case .single,
             .indexedSingle,
             .cursorSingle:
            return true

        case .strategy(let strategy),
             .indexedStrategy(let strategy):
            return strategy.nextPage == nil || resultsCount < strategy.limit || strategy.limit == 0

        case .cursorStrategy(let strategy):
            return strategy.nextPage == nil || resultsCount < strategy.limit || strategy.limit == 0
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
            
        case .single,
             .indexedSingle,
             .cursorSingle:
            adjustedOption = self.option
            
        case .strategy(let strategy),
             .indexedStrategy(let strategy):
            let isLastPage = resultsCount < strategy.limit
            
            if let links = links, let updated = IndexedPaginationStrategy(links: links) {
                strategy.currentPage = updated.currentPage
                strategy.nextPage = updated.nextPage
                strategy.prevPage = updated.prevPage
                strategy.firstPage = updated.firstPage
                strategy.lastPage = updated.lastPage
            } else {
                strategy.currentPage = strategy.firstPage
            }
            
            if isLastPage {
                strategy.lastPageReached()
            }
            
            adjustedOption = .indexedStrategy(strategy)

        case .cursorStrategy(let strategy):
            let isLastPage = resultsCount < strategy.limit

            if let links = links, let updated = CursorPaginationStrategy(links: links) {
                strategy.currentPage = updated.currentPage
                strategy.nextPage = updated.nextPage
                strategy.prevPage = updated.prevPage
                strategy.firstPage = updated.firstPage
                strategy.lastPage = updated.lastPage
            } else {
                strategy.currentPage = strategy.firstPage
            }

            if isLastPage {
                strategy.lastPageReached()
            }

            adjustedOption = .cursorStrategy(strategy)
        }
        self.option = adjustedOption
    }
}

extension RequestPagination {
    
    /// Request pagination options.
    public enum Option {

        /// Option for single page request.
        @available(*, deprecated, renamed: "indexedSingle")
        case single(index: Int, limit: Int, order: PaginationOrder)

        /// Option for single page request.
        case indexedSingle(index: Int, limit: Int, order: PaginationOrder)

        /// Option for single page request.
        case cursorSingle(cursor: String, limit: Int, order: PaginationOrder)

        /// Option with strategy provided.
        /// Strategy reference should be updated in `request...` func according to response.
        @available(*, deprecated, renamed: "indexedStrategy")
        case strategy(_ strategy: IndexedPaginationStrategy)

        /// Option with strategy provided.
        /// Strategy reference should be updated in `request...` func according to response.
        case indexedStrategy(_ strategy: IndexedPaginationStrategy)

        /// Option with strategy provided.
        /// Strategy reference should be updated in `request...` func according to response.
        case cursorStrategy(_ strategy: CursorPaginationStrategy)
    }

}

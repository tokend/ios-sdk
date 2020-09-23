import XCTest
import TokenDSDK
import DLCryptoKit
import DLJSONAPI

/// swiftlint:disable force_try
class RequestPaginationTests: XCTestCase {
    
    lazy var resourcePool: ResourcePool = ResourcePool(
        queue: DispatchQueue(label: "test.queue", attributes: .concurrent)
    )
    
    // MARK: -
    
    func testPaginationAdjustment() {
        let strategy = IndexedPaginationStrategy(index: 1, limit: 15, order: .descending)
        
        let pagination = RequestPagination(.strategy(strategy))
        
        pagination.adjustPagination(resultsCount: 15, links: nil)
        
        guard let currentPage = strategy.currentPage else {
            XCTAssert(false, "Current page is not set to adjusted strategy")
            return
        }
        
        XCTAssert(currentPage.index == 2, "Wrong current page index (\(currentPage.index)). Expected (\(2))")
        
        XCTAssert(true)
    }
    
    func testPaginationAdjustmentLastReached() {
        let strategy = IndexedPaginationStrategy(index: 5, limit: 15, order: .descending)
        
        let pagination = RequestPagination(.strategy(strategy))
        
        pagination.adjustPagination(resultsCount: 14, links: nil)
        
        guard let currentPage = strategy.currentPage else {
            XCTAssert(false, "Current page is not set to adjusted strategy")
            return
        }
        guard let lastPage = strategy.lastPage else {
            XCTAssert(false, "Last page is nil after adjustment")
            return
        }
        
        XCTAssert(currentPage.index == 6, "Wrong current page index (\(currentPage.index)). Expected (\(6))")
        XCTAssert(lastPage.index == 6, "Wrong last page index (\(lastPage.index)). Expected (\(6))")
        
        guard strategy.nextPage == nil else {
            XCTAssert(false, "Next page should not occur after last page reached")
            return
        }
        
        XCTAssert(true)
    }
    
    func testPaginationAdjustmentLinks() {
        let data = Data(jsonFileName: "Links")
        
        let document: Document<[Resource]>
        do {
            document = try Deserializer.Collection(resourcePool: self.resourcePool).deserialize(data: data)
        } catch let error {
            XCTAssert(false, "Links deserialize error: \(error.localizedDescription)")
            return
        }
        
        let strategy = IndexedPaginationStrategy(index: nil, limit: 15, order: .descending)
        guard strategy.currentPage == nil else {
            XCTAssert(false, "Current page is not nil after strategy init")
            return
        }
        guard strategy.lastPage == nil else {
            XCTAssert(false, "Last page is not nil after strategy init")
            return
        }
        
        let pagination = RequestPagination(.strategy(strategy))
        
        pagination.adjustPagination(resultsCount: 15, links: document.links)
        
        guard let currentPage = strategy.currentPage else {
            XCTAssert(false, "Current page is not set to adjusted strategy")
            return
        }
        
        XCTAssert(currentPage.index == 0, "Wrong current page index (\(currentPage.index)). Expected (\(0))")
        
        guard let lastPage = strategy.lastPage else {
            XCTAssert(false, "Last page is not set to adjusted strategy")
            return
        }
        XCTAssert(lastPage.index == 1, "Wrong last page index (\(lastPage.index)). Expected (\(1))")
        
        XCTAssert(true)
    }
}
/// swiftlint:enable force_try

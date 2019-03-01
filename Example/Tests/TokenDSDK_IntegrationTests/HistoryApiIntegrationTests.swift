import XCTest
import TokenDSDK
import TokenDWallet
import DLCryptoKit

class HistoryApiIntegrationTests: BaseIntegrationTests {
    
    // MARK: - Public properties
    
    public var balances: [BalanceDetails]?
    public var balancesError: Swift.Error?
    
    public let historyRequestLimit: Int = 10
    
    // MARK: - Overridden
    
    override func setUp() {
        super.setUp()
        
        guard self.isSignedIn else {
            print("Failed to sign")
            return
        }
        
        var balancesRequested = false
        self.requestBalances(completion: {
            balancesRequested = true
        })
        while !balancesRequested {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
    
    // MARK: - Public
    
    override func shouldSignIn() -> Bool {
        return false
    }
    
    func testHistoryForBalances() {
        guard self.shouldSignIn() else {
            XCTAssert(true)
            return
        }
        
        guard let balances = self.balances else {
            XCTAssert(false, "Failed to fetch balances: \(String(describing: self.balancesError))")
            return
        }
        
        guard balances.count > 0 else {
            XCTAssert(false, "No balances fetched")
            return
        }
        
        var expectations: [XCTestExpectation] = []
        for balance in balances {
            let expectation = XCTestExpectation(description: "Request history")
            self.requestHistoryForBalance(
                balanceId: balance.balanceId,
                onSuccess: {
                    XCTAssert(true)
                    expectation.fulfill()
            },
                onFail: { (errorMessage) in
                    XCTAssert(false, errorMessage)
                    expectation.fulfill()
            })
            expectations.append(expectation)
        }
        self.wait(for: expectations, timeout: BaseIntegrationTests.requestTimeoutDuraton)
    }
    
    // MARK: - Private
    
    private func requestBalances(completion: @escaping () -> Void) {
        self.api.balancesApi.requestDetails(
            accountId: self.walletData.accountId,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    self?.balancesError = error
                    
                case .success(let balances):
                    self?.balances = balances
                }
                
                completion()
        })
    }
    
    func requestHistoryForBalance(
        balanceId: String,
        onSuccess: @escaping () -> Void,
        onFail: @escaping (_ errorMessage: String) -> Void
        ) {
        
        let filters = HistoryRequestFiltersV3.with(.balance(balanceId))
        self.apiV3.historyApi.requestHistory(
            filters: filters,
            include: nil,
            pagination: RequestPagination(.single(index: 0, limit: self.historyRequestLimit, order: .descending)),
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    onFail("Failed to fetch balance history: \(error)")
                    
                case .success(let document):
                    guard document.data != nil else {
                        onFail("Failed to fetch balance history: empty `data`")
                        return
                    }
                    
                    onSuccess()
                }
        })
    }
}

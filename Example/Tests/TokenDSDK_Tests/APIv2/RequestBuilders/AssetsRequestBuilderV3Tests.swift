import XCTest
import TokenDSDK
import DLJSONAPI

/// swiftlint:disable line_length
class AssetsRequestBuilderV3Tests: BaseJSONAPIRequestBuilderTests {
    
    let requestBuilder = AssetsRequestBuilderV3(builderStack: BaseJSONAPIRequestBuilderTests.builderStack)
    
    func testAssetsRequest() {
        let testOptions: [(
            pagination: RequestPagination.Option,
            description: String,
            expectedUrl: String
            )] = [
                (
                    pagination: .single(index: 0, limit: 10, order: .ascending),
                    description: "page model",
                    expectedUrl: "/v3/assets?page[number]=0&page[limit]=10&page[order]=asc"
                ),
                (
                    pagination: .single(index: 1, limit: 20, order: .descending),
                    description: "page model",
                    expectedUrl: "/v3/assets?page[number]=1&page[limit]=20&page[order]=desc"
                ),
                (
                    pagination: .strategy(IndexedPaginationStrategy(index: nil, limit: 30, order: .ascending)),
                    description: "page model",
                    expectedUrl: "/v3/assets?page[number]=0&page[limit]=30&page[order]=asc"
                )
        ]
        
        for option in testOptions {
            return self.checkBuildAssets(
                description: option.description,
                pagination: RequestPagination(option.pagination),
                expectedUrl: option.expectedUrl
            )
        }
    }
    
    private func checkBuildAssets(
        description: String,
        pagination: RequestPagination,
        expectedUrl: String
        ) {
        
        let request = self.requestBuilder.buildAssetsRequest(pagination: pagination)
        
        let expectedHTTPMethod = RequestMethod.get
        XCTAssert(
            request.method == expectedHTTPMethod,
            "Wrong HTTP method for \(description). Expected (\(expectedHTTPMethod)). Got (\(request.method))"
        )
        
        let path = request.path + "?" + request.queryItems.map({ (item) -> String in
            return item.name + "=" + (item.value ?? "")
        }).joined(separator: "&")
        
        XCTAssert(
            path == expectedUrl,
            "Wrong url for \(description). Expected (\(expectedUrl)). Got (\(path))"
        )
    }
}
/// swiftlint:enable line_length

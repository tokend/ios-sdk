import Foundation
import DLJSONAPI

// MARK: - LikeSaleResource

extension Nifty {
    open class LikeSaleResource: Resource {

        open override class var resourceType: String {
            return "likes-data"
        }

        public enum CodingKeys: String, CodingKey {
            case sales
            case pools
        }
        
        open var sales: [Nifty.SaleResource]? {
            return self.relationCollectionOptionalValue(key: CodingKeys.sales)
        }

        open var pools: [Nifty.SecondaryMarketResource]? {
            return self.relationCollectionOptionalValue(key: CodingKeys.pools)
        }
    }
}


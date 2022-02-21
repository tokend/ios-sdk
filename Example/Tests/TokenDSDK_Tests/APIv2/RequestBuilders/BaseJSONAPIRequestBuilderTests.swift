import XCTest
import TokenDSDK
import DLCryptoKit
import DLJSONAPI

// swiftlint:disable force_try
class BaseJSONAPIRequestBuilderTests: XCTestCase {
    
    public static let builderStack: JSONAPI.BaseApiRequestBuilderStack = {
        let apiConfiguration = ApiConfiguration(
            urlString: "https://tokend.org/api"
        )
        
        let requestSigner = JSONAPI.RequestSigner(
            keyDataProvider: UnsafeRequestSignKeyDataProvider(
                keyPair: try! ECDSA.KeyData()
            ),
            accountIdProvider: UnsafeRequestSignAccountIdProvider(
                accountId: "accountId"
            ))
        
        let network = JSONAPI.AlamofireNetwork(
            resourcePool: ResourcePool(queue: DispatchQueue(label: "test")),
            onUnathorizedRequest: { _ in }
        )
        
        return JSONAPI.BaseApiRequestBuilderStack(
            apiConfigurationProvider: apiConfiguration,
            requestSigner: requestSigner,
            network: network
        )
    }()
}
// swiftlint:enable force_try

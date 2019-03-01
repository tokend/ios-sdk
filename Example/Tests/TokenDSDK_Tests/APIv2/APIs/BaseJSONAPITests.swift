import XCTest
import TokenDSDK
import DLCryptoKit
import DLJSONAPI

// swiftlint:disable force_try
class BaseJSONAPITests: XCTestCase {
    
    public static let apiStack: JSONAPI.BaseApiStack = {
        let apiConfiguration = ApiConfiguration(
            urlString: "https://tokend.org/api"
        )
        
        let callbacks = JSONAPI.ApiCallbacks(
            onUnathorizedRequest: { _ in }
        )
        
        var resourcePool: ResourcePool = ResourcePool(
            queue: DispatchQueue(label: "test.queue", attributes: .concurrent)
        )
        
        let network = JSONAPI.AlamofireNetwork(
            resourcePool: resourcePool,
            userAgent: nil,
            onUnathorizedRequest: { _ in }
        )
        
        let keyPair = try! ECDSA.KeyData()
        
        let requestSignerV3 = JSONAPI.RequestSigner(
            keyDataProvider: UnsafeRequestSignKeyDataProvider(
                keyPair: keyPair
        ))
        
        return JSONAPI.BaseApiStack(
            apiConfiguration: apiConfiguration,
            callbacks: callbacks,
            network: network,
            requestSigner: requestSignerV3
        )
    }()
    
    public let baseApi: JSONAPI.BaseApi = {
        return JSONAPI.BaseApi(apiStack: BaseJSONAPITests.apiStack)
    }()
    
    // MARK: -
    
}
// swiftlint:enable force_try

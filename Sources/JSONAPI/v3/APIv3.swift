import Foundation
import DLJSONAPI

/// Class provides an access to APIs that are created in lazy manner.
public class APIv3 {
    
    // MARK: - Public properties
    
    public let configuration: ApiConfiguration
    public let callbacks: JSONAPI.ApiCallbacks
    public let network: JSONAPI.NetworkProtocol
    public let requestSigner: JSONAPI.RequestSignerProtocol
    
    public private(set) lazy var baseApiStack: JSONAPI.BaseApiStack = {
        return JSONAPI.BaseApiStack(
            apiConfiguration: self.configuration,
            callbacks: self.callbacks,
            network: self.network,
            requestSigner: self.requestSigner
        )
    }()
    
    public private(set) lazy var accountsApi: AccountsApiV3 = { return self.create(AccountsApiV3.self) }()
    public private(set) lazy var assetPairsApi: AssetPairsApiV3 = { return self.create(AssetPairsApiV3.self) }()
    public private(set) lazy var assetsApi: AssetsApiV3 = { return self.create(AssetsApiV3.self) }()
    public private(set) lazy var balancesApi: BalancesApiV3 = { return self.create(BalancesApiV3.self) }()
    public private(set) lazy var historyApi: HistoryApiV3 = { return self.create(HistoryApiV3.self) }()
    public private(set) lazy var offersApi: OffersApiV3 = { return self.create(OffersApiV3.self) }()
    public private(set) lazy var orderBookApi: OrderBookApiV3 = { return self.create(OrderBookApiV3.self) }()
    public private(set) lazy var salesApi: SalesApiV3 = { return self.create(SalesApiV3.self) }()
    
    // MARK: -
    
    public init(
        configuration: ApiConfiguration,
        callbacks: JSONAPI.ApiCallbacks,
        network: JSONAPI.NetworkProtocol,
        requestSigner: JSONAPI.RequestSignerProtocol
        ) {
        
        self.configuration = configuration
        self.callbacks = callbacks
        self.network = network
        self.requestSigner = requestSigner
        
        APIv3.registerResources()
    }
    
    // MARK: - Public
    
    public static func registerResources() {
        AllResources.registerAllResources()
    }
    
    // MARK: - Private
    
    private func create<ApiType: JSONAPI.BaseApi>(_ type: ApiType.Type) -> ApiType {
        let api = type.init(apiStack: self.baseApiStack)
        return api
    }
}

extension Resource: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        guard
            let jsonData = try? self.documentData(),
            let jsonString = String(data: jsonData, encoding: .utf8)
            else {
                return String(describing: self)
        }
        
        return jsonString
    }
}

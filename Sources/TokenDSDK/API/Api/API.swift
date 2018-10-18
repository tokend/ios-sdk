import Foundation

/// Class provides an access to APIs that are created in lazy manner.
public class API {
    
    private let requestSigner: RequestSignerProtocol
    
    // MARK: - Public properties
    
    public let configuration: ApiConfiguration
    public let callbacks: ApiCallbacks
    public let network: Network
    
    public private(set) lazy var baseApiStack: BaseApiStack = {
        return BaseApiStack(
            apiConfiguration: self.configuration,
            callbacks: self.callbacks,
            network: self.network,
            requestSigner: self.requestSigner,
            verifyApi: self.verifyApi
        )
    }()
    
    public private(set) lazy var accountApi: AccountApi           = { return self.createAccountApi() }()
    public private(set) lazy var assetPairsApi: AssetPairsApi     = { return self.createAssetPairsApi() }()
    public private(set) lazy var assetsApi: AssetsApi             = { return self.createAssetsApi() }()
    public private(set) lazy var balancesApi: BalancesApi         = { return self.createBalancesApi() }()
    public private(set) lazy var chartsApi: ChartsApi             = { return self.createChartsApi() }()
    public private(set) lazy var generalApi: GeneralApi           = { return self.createGeneralApi() }()
    public private(set) lazy var offersApi: OffersApi             = { return self.createOffersApi() }()
    public private(set) lazy var orderBookApi: OrderBookApi       = { return self.createOrderBookApi() }()
    public private(set) lazy var salesApi: SalesApi               = { return self.createSalesApi() }()
    public private(set) lazy var tfaApi: TFAApi                   = { return self.createTFAApi() }()
    public private(set) lazy var transactionsApi: TransactionsApi = { return self.createTransactionsApi() }()
    public private(set) lazy var verifyApi: TFAVerifyApi          = { return self.createTFAVerifyApi() }()
    
    // MARK: -
    
    public init(
        configuration: ApiConfiguration,
        callbacks: ApiCallbacks,
        keyDataProvider: RequestSignKeyDataProviderProtocol
        ) {
        
        self.configuration = configuration
        self.callbacks = callbacks
        self.network = Network(userAgent: configuration.userAgent)
        
        self.requestSigner = RequestSigner(keyDataProvider: keyDataProvider)
    }
    
    // MARK: - Private
    
    private func createBalancesApi() -> BalancesApi {
        let api = BalancesApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createTransactionsApi() -> TransactionsApi {
        let api = TransactionsApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createOffersApi() -> OffersApi {
        let api = OffersApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createOrderBookApi() -> OrderBookApi {
        let api = OrderBookApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createAssetsApi() -> AssetsApi {
        let api = AssetsApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createAssetPairsApi() -> AssetPairsApi {
        let api = AssetPairsApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createAccountApi() -> AccountApi {
        let api = AccountApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createGeneralApi() -> GeneralApi {
        let api = GeneralApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createChartsApi() -> ChartsApi {
        let api = ChartsApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createSalesApi() -> SalesApi {
        let api = SalesApi(apiStack: self.baseApiStack)
        return api
    }
    
    private func createTFAApi() -> TFAApi {
        let api = TFAApi(
            apiConfiguration: self.baseApiStack.apiConfiguration,
            requestSigner: self.baseApiStack.requestSigner,
            callbacks: self.baseApiStack.callbacks
        )
        return api
    }
    
    private func createTFAVerifyApi() -> TFAVerifyApi {
        let api = TFAVerifyApi(
            apiConfiguration: self.configuration,
            requestSigner: self.requestSigner
        )
        return api
    }
}

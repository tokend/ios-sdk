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
    
    public private(set) lazy var accountsApi: AccountsApiV3 = { return self.create() }()
    public private(set) lazy var assetPairsApi: AssetPairsApiV3 = { return self.create() }()
    public private(set) lazy var assetsApi: AssetsApiV3 = { return self.create() }()
    public private(set) lazy var balancesApi: BalancesApiV3 = { return self.create() }()
    public private(set) lazy var historyApi: HistoryApiV3 = { return self.create() }()
    public private(set) lazy var keyValuesApi: KeyValuesApiV3 = { return self.create() }()
    public private(set) lazy var offersApi: OffersApiV3 = { return self.create() }()
    public private(set) lazy var orderBookApi: OrderBookApiV3 = { return self.create() }()
    public private(set) lazy var salesApi: SalesApiV3 = { return self.create() }()
    public private(set) lazy var pollsApi: PollsApiV3 = { return self.create() }()
    public private(set) lazy var atomicSwapApi: AtomicSwapApiV3 = { return self.create() }()
    public private(set) lazy var requetsApi: RequestsApiV3 = { return self.create() }()
    public private(set) lazy var integrationsApi: IntegrationsApiV3 = { return self.create() }()
    public private(set) lazy var cardsApi: CardsApi = { return self.create() }()
    public private(set) lazy var friendsApi: FriendsApi = { return self.create() }()
    public private(set) lazy var transactionsApi: TransactionsApiV3 = { return self.create() }()
    public private(set) lazy var recurringPaymentsApi: RecurringPaymentsApiV3 = { return create() }()
    public private(set) lazy var invoicesApi: InvoicesApiV3 = { return create() }()
    public private(set) lazy var invitationsApi: InvitationsApiV3 = { return create() }()
    public private(set) lazy var testResultsApi: TestResultsApiV3 = { return create() }()
    public private(set) lazy var kycApi: KYCApiV3 = { return create() }()
    public private(set) lazy var bookingApi: BookingApiV3 = { return create() }()
    public private(set) lazy var schedulerApi: SchedulerApiV3 = { return create() }()
    
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
        Cards.AllResources.registerAllResources()
        Friends.AllResources.registerAllResources()
        Horizon.AllResources.registerAllResources()
        Invoices.AllResources.registerAllResources()
        Recpayments.AllResources.registerAllResources()
        Invitations.AllResources.registerAllResources()
        MunaTestResults.AllResources.registerAllResources()
        KYC.AllResources.registerAllResources()
        MunaBooking.AllResources.registerAllResources()
        MunaScheduler.AllResources.registerAllResources()
        MunaVaccineResults.AllResources.registerAllResources()
    }
    
    // MARK: - Private

    private func create<ApiType: JSONAPI.BaseApi>() -> ApiType {
        let api = ApiType.init(apiStack: self.baseApiStack)
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

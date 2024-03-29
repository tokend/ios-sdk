import UIKit
import CoreServices
import DLCryptoKit
import DLJSONAPI
import RxCocoa
import RxSwift
import SnapKit
import TokenDSDK
import TokenDWallet

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length
class ApiExampleViewControllerV3: UIViewController, RequestSignKeyDataProviderProtocol, RequestSignAccountIdProviderProtocol, ApiConfigurationProviderProtocol {
    
    var privateKey: ECDSA.KeyData? = try? ECDSA.KeyData(
        seed: Base32Check.decodeCheck(
            expectedVersion: .seedEd25519,
            encoded: Constants.masterKeySeed
        )
    )
    
    func getPrivateKeyData(completion: @escaping (ECDSA.KeyData?) -> Void) {
        completion(self.privateKey)
    }
    
    func getPublicKeyString(completion: @escaping (String?) -> Void) {
        guard let publicKeyData = self.privateKey?.getPublicKeyData() else {
            completion(nil)
            return
        }

        let publicKey = Base32Check.encode(version: .accountIdEd25519, data: publicKeyData)
        completion(publicKey)
    }
    
    func getAccountId(completion: @escaping (String?) -> Void) {
        completion(nil)
    }
    
    lazy var apiConfig: ApiConfiguration = {
        return ApiConfiguration(
            urlString: Constants.apiUrlString
        )
    }()
    
    var apiConfiguration: ApiConfiguration {
        apiConfig
    }
    
    lazy var apiCallbacks: JSONAPI.ApiCallbacks = {
        return JSONAPI.ApiCallbacks(
            onUnathorizedRequest: { (error) in
                print("on unauthorized: \(error.localizedDescription)")
        })
    }()
    
    lazy var resourcePool: ResourcePool = ResourcePool(
        queue: DispatchQueue(label: "test.queue", attributes: .concurrent)
    )
    
    lazy var alamofireNetwork: JSONAPI.AlamofireNetwork = {
        return JSONAPI.AlamofireNetwork(
            resourcePool: self.resourcePool,
            userAgent: nil,
            onUnathorizedRequest: self.apiCallbacks.onUnathorizedRequest
        )
    }()
    var network: JSONAPI.NetworkProtocol {
        return self.alamofireNetwork
    }
    
    let vc = ApiExampleViewController()
    
    lazy var tokenDApi: TokenDSDK.APIv3 = {
        let api = TokenDSDK.APIv3(
            configurationProvider: self,
            callbacks: self.apiCallbacks,
            network: self.network,
            requestSigner: JSONAPI.RequestSigner(keyDataProvider: self, accountIdProvider: self)
        )
        return api
    }()
    
    let disposeBag = DisposeBag()
    
    var inputTFAText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alamofireNetwork.startLogger()
        
        let testButton = UIButton(type: .system)
        testButton.setTitle("Test", for: .normal)
        
        testButton.addTarget(self, action: #selector(self.runTest), for: .touchUpInside)
        
        self.view.addSubview(testButton)
        testButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    @objc func runTest() {
        self.addChild(self.vc)
//        self.tokenDApi.accountsApi.requestAccount(
//            // id 17
//            accountId: "GDGUMUW7RVCLW5UA7426SVQLGXBPHOFIX4GI55MIINAWHNGSTJ2SKJXP",
//            include: [],
//            pagination: nil,
//            completion: { [weak self] (result) in
//
//                switch result {
//
//                case .failure(let error):
//                    break
//
//                case .success(let document):
//                    print(document)
//                }
//        })

//        self.tokenDApi.keyValuesApi.requestKeyValueEntries(
//            pagination: .init(.single(index: 0, limit: 100, order: .descending)),
//            completion: { [weak self] (result) in
//
//                switch result {
//
//                case .failure:
//                    break
//
//                case .success(let document):
//                    print(document)
//                }
//        })

//        let filters = InvitationsRequestFiltersV3.with(.states([1]))
//            .addFilter(.guest(""))
//        self.tokenDApi.invitationsApi.getSortedInvitations(
//            filters: filters,
//            sort: .updatedAt(descending: true),
//            include: [],
//            pagination: .init(.indexedSingle(index: 0, limit: 100, order: .descending)),
//            completion: { [weak self] (result) in
//
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success(let document):
//                    print(document)
//                }
//        })
        
//        self.requestSystemInfo()
//        self.requestRecurringPayment()
//        self.requestRemoveCard()
//        self.requestAddCard()
//        self.requestUpdateCard()
//        self.sendTransaction()
//        self.requestUser()
//        self.requestCards()
//        self.requestCard()
//        self.requestFriends()
//        self.requestRecentPayments()
//        self.requestAddCard()
    }
    
    // MARK: -
    
    func getProxyPaymentAccount() {
        self.tokenDApi.integrationsApi.requestProxyPaymentAccount( completion: { (result) in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
                
            case .success(let document):
                guard let account = document.data else {
                    return
                }
                print("Success: \(account.id!)")
            }
        })
    }

    func sendTransaction() {
        self.tokenDApi.transactionsApi.requestSubmitTransaction(
            envelope: "AAAAAEHCX5tmu0fXlkE9GLIOLO185ih5QI7V+PZ1mtb1tnzSYnlC9X/Rmn8AAAAAAAAAAAAAAABfCILaAAAAAAAAAAEAAAAAAAAAAQAAAAC2EsGJoLO2k8GqKqcWk3sevtAWt/fmb5gjXHppbHgjcAAAAAAAAAAAAAAADgAAAAEAAAAAQcJfm2a7R9eWQT0Ysg4s7XzmKHlAjtX49nWa1vW2fNIAAAAAAAAADwAAA+gAAAAAAAAAAnt9AAAAAAAAAAAAAAAAAAAAAAAB9bZ80gAAAECrpJFf4av3UMUkUREYK0cAcgJG/ewL1fQJEDVVADIAGO5jzJ2MnVk1NsHvpAKbYBMz9UQ/znr6gf+a5n9niK8D",
            waitForIngest: false,
            completion: { (result) in

                switch result {

                case .failure(let error):
                    print(error)

                case .success(let document):
                    print(document)
                }
        })
    }
    
    func requestConvertedBalances() {
        self.tokenDApi.accountsApi.requestConvertedBalances(
            accountId: Constants.userAccountId,
            convertationAsset: "UAH",
            include: ["states", "balance", "balance.state", "balance.asset"],
            completion: { (result) in
                switch result {
                case .failure(let error):
                    print("ERROR: \(error)")
                    
                case .success(let document):
                    guard let data = document.data else {
                        print("ERROR: EMPTY")
                        return
                    }
                    
                    print("Success: \(data)")
                }
        })
    }
    
    func requestBusiness() {
        self.tokenDApi.integrationsApi.requestBusiness(
            accountId: "GDF2KPCIOOLADKDIXIRFTEKCW4RKACBQNAYWVINXOASNH6YYMCVEZ2BA",
            completion: { (result) in
                switch result {
                case .failure(let error):
                    print("ERROR: \(error)")
                    
                case .success(let document):
                    guard let data = document.data else {
                        print("ERROR: EMPTY")
                        return
                    }
                    print("Success: \(data)")
                }
        })
    }
    
    func addBusiness() {
        self.tokenDApi.integrationsApi.addBusinesses(
            clientAccountId: "GAI2AGVAERR5XAZ7JEASZDFESNEBBH2R6DN6UMYI3UYXKP5TQOFGXPOL",
            businessAccountId: "GBYADDE267JDJNZ5TV2FQKEHWBU4QA6D5EQHNNSVBRLFKFKAK462WTYK",
            completion: { (response) in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success:
                    print("Success")
                }
        }
        )
    }
    
    func requestAccount() {
        self.tokenDApi.accountsApi.requestAccount(
            accountId: Constants.userAccountId,
            include: ["external_system_ids"],
            pagination: nil,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    self?.showError(error)
                    
                case .success(let document):
                    print("account document: \(document)")
                }
        })
    }

//    func requestCards() {
//        let filters = CardsRequestsFilters.with(.owner(Constants.userAccountId))
//        let pagination = RequestPagination(.indexedSingle(index: 0, limit: 20, order: .descending))
//        self.tokenDApi.cardsApi.requestCards(
//            filters: filters,
//            include: ["balance"],
//            pagination: pagination,
//            completion: { [weak self] (result) in
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success(let document):
//                    print("cards document: \(document)")
//                }
//        })
//    }
//
//    func requestCard() {
//        self.tokenDApi.cardsApi.requestCard(
//            cardNumber: "6635008740148757",
//            include: ["balance", "security_details"],
//            completion: { [weak self] (result) in
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success(let document):
//                    print(document)
//                }
//        })
//    }

    func requestUser() {
        self.tokenDApi.integrationsApi.sendManyUsersRequest(
            userAccountIds: ["GCNSSQMRQZNWNXXBBBFUVYSR5WPDD6R7MCUDR5W3UR4BYH4NNKJNFFNA"],
            completion: { [weak self] (result) in
                    switch result {

                    case .failure(let error):
                        self?.showError(error)

                    case .success(let document):
                        print(document)
                    }
            })
    }

    func requestAddCard() {
//        self.tokenDApi.cardsApi.requestAddCard(
//            cardNumber: "4242424242424242",
//            accountId: Constants.userAccountId,
//            balanceIds: [
//                "balanceId1",
//                "balanceId2"
//            ],
//            completion: { [weak self] (result) in
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success:
//                    print("add card success")
//                }
//        })
    }

//    func requestSystemInfo() {
//        self.tokenDApi.recurringPaymentsApi.requestSystemInfo { [weak self] (result) in
//
//            switch result {
//
//            case .failure(let error):
//                self?.showError(error)
//
//            case .success(let document):
//                print(document.data)
//            }
//        }
//    }
//
//    func requestRecurringPayments() {
//        let filters = RecurringPaymentsRequestsFilters.with(.sourceAccount(Constants.userAccountId))
//        let pagination = RequestPagination(.indexedSingle(index: 0, limit: 20, order: .descending))
//
//        self.tokenDApi.recurringPaymentsApi.requestScheduledPayments(
//            filters: filters,
//            include: ["description"],
//            pagination: pagination,
//            completion: { [weak self] (result) in
//
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success(let document):
//                    print(document.data)
//                }
//        })
//    }
//
//    func requestRecurringPayment() {
//
//        self.tokenDApi.recurringPaymentsApi.requestDeleteScheduledPayment(
//            id: "7",
//            completion: { [weak self] (result) in
//
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success:
//                    print("success")
//                }
//        })
//
//        self.tokenDApi.recurringPaymentsApi.requestScheduledPayment(
//            id: "7",
//            include: ["description"],
//            completion: { [weak self] (result) in
//
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success(let document):
//                    print(document.data)
//                }
//        })
//    }
//
//    func requestRemoveCard() {
//        self.tokenDApi.cardsApi.requestDeleteCard(
//            cardNumber: "5359421088825421",
//            completion: { [weak self] (result) in
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success:
//                    print("remove card success")
//                }
//        })
//    }
//
//    func requestUpdateCard() {
//        self.tokenDApi.cardsApi.requestUpdateCard(
//            by: "4242424242424242",
//            bindBalanceIds: [
//                "balanceId3",
//                "balanceId4"
//            ],
//            unbindBalanceIds: [],
//            completion: { [weak self] (result) in
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success:
//                    print("update card success")
//                }
//        })
//    }
//
//    func requestFriends() {
//        self.tokenDApi.friendsApi.requestFriends(
//            accountId: Constants.userAccountId,
//            include: nil,
//            pagination: .init(.indexedSingle(index: 0, limit: 20, order: .descending)),
//            completion: { [weak self] (result) in
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success(let document):
//                    print("friends document: \(document)")
//                }
//        })
//    }
//
//    func requestRecentPayments() {
//        self.tokenDApi.friendsApi.requestRecentPayments(
//            accountId: Constants.userAccountId,
//            filters: .init(),
//            include: [],
//            pagination: .init(.indexedSingle(index: 0, limit: 20, order: .descending)),
//            completion: { [weak self] (result) in
//                switch result {
//
//                case .failure(let error):
//                    self?.showError(error)
//
//                case .success(let document):
//                    print("recent payments: \(document)")
//                }
//        })
//    }
    
    func requestAtomicSwapAsks() {
        let filters = AtomicSwapFiltersV3.with(.baseAsset("82745DB9210D4AD4"))
        
        let pagination = RequestPagination(.indexedSingle(index: 0, limit: 20, order: .descending))
        self.tokenDApi.atomicSwapApi
            .requestAtomicSwapAsks(
                filters: filters,
                include: ["quote_assets"],
                pagination: pagination,
                onRequestBuilt: nil,
                completion: { (response) in
                    switch response {
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    case .success(let document):
                        if let data = document.data {
                            print("Success: \(data)")
                        } else {
                            print("Error: empty data")
                        }
                    }
            }
        )
    }
    
    func requestRequests() {
        let filters = RequestsFiltersV3.with(.requestor(Constants.userAccountId))
        
        let pagination = RequestPagination(.indexedSingle(index: 0, limit: 20, order: .descending))
        self.tokenDApi.requetsApi
            .requestRequests(
                filters: filters,
                include: ["request_details"],
                pagination: pagination,
                onRequestBuilt: nil,
                completion: { (response) in
                    switch response {
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    case .success(let document):
                        if let data = document.data {
                            print("Success: \(data)")
                        } else {
                            print("Error: empty data")
                        }
                    }
            }
        )
    }
    
    func requestAccountRequests() {
        let accountId = Constants.userAccountId
        let requestId = "131"
        let pagination = RequestPagination(.indexedSingle(index: 0, limit: 20, order: .descending))
        
        self.tokenDApi.accountsApi.requestAccountRequest(
            accountId: accountId,
            requestId: requestId,
            pagination: pagination,
            completion: { (response) in
                switch response {
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                case .success(let document):
                    guard let request = document.data else {
                        print("ERROR: Empty data")
                        return
                    }
                    print("Success: \(request)")
                }
        })
    }
    
    func requestBusinesses() {
        self.tokenDApi.integrationsApi.requestBusinesses(
            accountId: Constants.userAccountId,
            completion: { (result) in
                switch result {
                case .failure(let error):
                    print("ERROR: \(error)")
                    
                case .success(let document):
                    guard let data = document.data else {
                        print("ERROR: EMPTY")
                        return
                    }
                    print("Success: \(data)")
                }
        })
    }
    
    func requestPolls() {
        let filter = PollsRequestFiltersV3.with(
            .owner("GBA4EX43M25UPV4WIE6RRMQOFTWXZZRIPFAI5VPY6Z2ZVVXVWZ6NEOOB")
        )
        let single = RequestPagination.Option.indexedSingle(
            index: 0,
            limit: 10,
            order: .descending
        )
        let pagination = RequestPagination(single)
        _ = self.tokenDApi.pollsApi.requestPolls(
            filters: filter,
            pagination: pagination,
            completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let document):
                    guard let resources = document.data else {
                        print("Data is empty.........")
                        return
                    }
                    print(resources)
                }
        })
    }
    
    private var loadAllVotesController: LoadAllResourcesController<Horizon.VoteResource>?
    func requestVotes() {
        let strategy = IndexedPaginationStrategy(
            index: nil,
            limit: 1,
            order: .descending
        )
        let pagination = RequestPagination( .indexedStrategy(strategy))
        self.loadAllVotesController = LoadAllResourcesController<Horizon.VoteResource>(
            requestPagination: pagination
        )
        
        self.loadAllVotesController?.loadResources(
            loadPage: { (pagination, completion) in
                _ = self.tokenDApi.pollsApi.requestVotesById(
                    voterAccountId: "GCREPRFV33DNIH5DE2KUXQZAKNJBR5CG4AO7T3ICGCYSMDTZE635CPPD",
                    pagination: pagination,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let error):
                            completion(.failed(error))
                            
                        case .success(let document):
                            let data = document.data ?? []
                            completion(.succeeded(data))
                        }
                })
        }, completion: { (result, data) in
            switch result {
            case .failed(let error):
                print("All votes loading failure: \(error)\n loaded data\n\(data)")
                
            case .succeded:
                print("Success")
                print(data)
            }
        })
    }
    
    private var loadAllAssetsController: LoadAllResourcesController<Horizon.AssetResource>?
    func requestAssetsV3() {
        let paginationStrategy = IndexedPaginationStrategy(index: nil, limit: 2, order: .ascending)
        self.loadAllAssetsController = LoadAllResourcesController(
            requestPagination: RequestPagination(.indexedStrategy(paginationStrategy))
        )
        
        self.loadAllAssetsController?.loadResources(
            loadPage: { [weak self] (pagination, completion) in
                self?.tokenDApi.assetsApi.requestAssets(
                    pagination: pagination,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let error):
                            completion(.failed(error))
                            
                        case .success(let document):
                            let data = document.data ?? []
                            completion(.succeeded(data))
                        }
                })
            },
            completion: { (result, data) in
                switch result {
                    
                case .failed(let error):
                    print("All assets load failed: \(error). Loaded: \(data)")
                    
                case .succeded:
                    print("All assets loaded: \(data)")
                }
        })
    }
    
    func requestHistory(
        balance: String,
        completion: @escaping (_ doc: Document<[Horizon.ParticipantsEffectResource]>) -> Void
        ) {
        
        let filters = HistoryRequestFiltersV3.with(
            .balance(balance)
        )
        
        let pagination = RequestPagination(.indexedSingle(index: 0, limit: 20, order: .descending))
        
        self.tokenDApi.historyApi.requestHistory(
            filters: filters,
            include: ["effect", "operation.details", "operation"],
            pagination: pagination,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    self.showError(error)
                    
                case .success(let document):
                    completion(document)
                }
        })
    }
    
    func requestMovements(
        account: String,
        completion: @escaping (_ doc: Document<[Horizon.ParticipantsEffectResource]>) -> Void
        ) {
        
        let filters = MovementsRequestFilterV3.with(
            .account(account)
        )
        
        let pagination = RequestPagination(.indexedSingle(index: 0, limit: 20, order: .descending))
        
        self.tokenDApi.historyApi.requestMovements(
            filters: filters,
            include: ["effect", "operation.details", "operation"],
            pagination: pagination,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    self.showError(error)
                    
                case .success(let document):
                    completion(document)
                }
        })
    }
    
    func requestMoreHistory(balance: String) {
        let filters = HistoryRequestFiltersV3.with(
            .balance(balance)
        )
        
        let pagination = RequestPagination(.indexedSingle(index: 0, limit: 3, order: .descending))
        
        var prevRequest: JSONAPI.RequestModel?
        
        self.tokenDApi.historyApi.requestHistory(
            filters: filters,
            include: ["effect", "operation.details", "operation"],
            pagination: pagination,
            onRequestBuilt: { (builtRequest) in
                prevRequest = builtRequest
        },
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    self.showError(error)
                    
                case .success(let document):
                    guard let links = document.links else {
                        print("No links in document")
                        return
                    }
                    
                    print("First page loaded: \(String(describing: document.data))")
                    
                    self.tokenDApi.historyApi.loadPageForLinks(
                        Horizon.ParticipantsEffectResource.self,
                        links: links,
                        page: .next,
                        previousRequest: prevRequest!,
                        shouldSign: true,
                        completion: { (nextDocResult) in
                            switch nextDocResult {
                                
                            case .failure(let error):
                                self.showError(error)
                                
                            case .success(let doc):
                                print("Next page loaded: \(String(describing: doc.data))")
                            }
                    })
                }
        })
    }
    
    func requestAssetByIdV3(assetId: String) {
        let assetsApi = self.tokenDApi.assetsApi
        
        assetsApi.requestAssetById(
            assetId: assetId,
            completion: { (result) in
                print("-----------------------------------------")
                
                switch result {
                    
                case .failure(let error):
                    print("Failure while fetching asset with id (\(assetId)): \(error.localizedDescription)")
                    
                case .success(let document):
                    print("Success while fetching asset with id: \(assetId)")
                    if let data = document.data {
                        if let id = data.id {
                            print("Asset id: \(id)")
                        }
                        
                        print("Data type: \(data.type)")
                        print("details: \(data.details)")
                    }
                }
        })
    }
    
    func requestAssetPair(
        baseAsset: String,
        quoteAsset: String
        ) {
        
        let assetPairsApi = self.tokenDApi.assetPairsApi
        
        assetPairsApi.requestAssetPair(
            baseAsset: "BTC",
            qupteAsset: "ETH",
            completion: { (result) in
                print("-----------------------------------------")
                
                switch result {
                    
                case .failure(let error):
                    print("Failure while fetching asset pair with base asset \(baseAsset) and quote asset \(quoteAsset): \(error.localizedDescription)")
                    
                case .success(let document):
                    print("Success while fetching aasset pair with base asset \(baseAsset) and quote asset \(quoteAsset)")
                    if let data = document.data {
                        print("Price: \(data.price)")
                    }
                }
        })
    }
    
    func requestOrderBookV3() {
        self.tokenDApi.orderBookApi.requestOffers(
            baseAsset: "SS0EE",
            quoteAsset: "EUR",
            orderBookId: "0",
            maxEntries: 10,
            include: self.tokenDApi.orderBookApi.requestBuilder.offersIncludeAll,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    print("Failed to request order book: \(error)")
                    
                case .success(let document):
                    print("Order book result: \(String(describing: document.data))")
                }
        })
    }
    
    func requestSalesV3() {
        let filters = SalesRequestFiltersV3
            .empty()
            .addFilter(.minSoftCap(1.0))
            .addFilter(.maxSoftCap(1000000.0))
            .addFilter(.maxEndTime(Date.distantFuture))
        
        let pagination = RequestPagination(.indexedSingle(index: 0, limit: 10, order: .ascending))
        
        self.tokenDApi.salesApi.getSales(
            filters: filters,
            pagination: pagination,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    print("Failed to request sales: \(error)")
                    
                case .success(let document):
                    print("Sales result: \(String(describing: document.data))")
                }
        })
    }
    
    func requestKeyValueEntries() {
        let pagination = IndexedPaginationStrategy(index: nil, limit: 100, order: .ascending)
        
        self.tokenDApi.keyValuesApi.requestKeyValueEntries(
            pagination: RequestPagination(.indexedStrategy(pagination)),
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    print("key value entries error: \(error)")
                    
                case .success(let document):
                    print("key value entries: \(String(describing: document.data))")
                }
        })
    }
    
    func uploadDocument() {
        let vc = UIImagePickerController()
        
        vc.sourceType = .photoLibrary
        vc.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        
        self.present(vc, animated: true, completion: nil)
    }
    
    //    func uploadDocument() {
    //        let vc = UIDocumentPickerViewController(
    //            documentTypes: [
    //                kUTTypePDF,
    //                kUTTypeGIF,
    //                kUTTypeJPEG,
    //                kUTTypePNG,
    //                kUTTypeTIFF
    //                ].map({ (type) -> String in
    //                    return type as String
    //                }),
    //            in: .import
    //        )
    //
    //        vc.delegate = self
    //
    //        self.present(vc, animated: true, completion: nil)
    //    }
    
    enum UploadOption {
        
        case imageUrl(URL)
        case image(UIImage)
    }
    
    func requestChangeRoleRequests() {
        let filters = ChangeRoleRequestsFiltersV3.with(.requestor(self.vc.accountId))
        let pagination = RequestPagination(.indexedStrategy(IndexedPaginationStrategy(
            index: 0,
            limit: 10,
            order: .descending))
        )
        
        self.tokenDApi.accountsApi.requestChangeRoleRequests(
            filters: filters,
            include: ["request_details"],
            pagination: pagination,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    print("Change role requests error: \(error.localizedDescription)")
                    
                case .success(let document):
                    guard let data = document.data else {
                        print("Change role requests empty data")
                        return
                    }
                    
                    print("Change role requests: \(data)")
                }
        })
    }
    
    func resizeImageToMaxSizePNGData(image: UIImage) -> Data? {
        var pngData = image.pngData()
        
        let imageSize = image.size
        let imageSquare: CGFloat = sqrt(imageSize.width * imageSize.height)
        let expectedImageSquare: CGFloat = 1500.0
        let estimatedDownScale: CGFloat = round((1.0 / (imageSquare / expectedImageSquare)) * 10.0) / 10.0 + 0.1
        var downScale: CGFloat = min(1.0, estimatedDownScale)
        var dataSize: Int = pngData?.count ?? 0
        while dataSize > DocumentsApi.maxRecommendedDocumentSize && downScale > 0.1 {
            downScale -= 0.1
            let downScaledSize = CGSize(
                width: round(imageSize.width * downScale),
                height: round(imageSize.width * downScale)
            )
            
            UIGraphicsBeginImageContextWithOptions(
                downScaledSize,
                false,
                image.scale
            )
            
            image.draw(in: CGRect(origin: CGPoint.zero, size: downScaledSize))
            let downScaledImage = UIGraphicsGetImageFromCurrentImageContext()
            pngData = downScaledImage?.pngData()
            dataSize = pngData?.count ?? 0
        }
        
        return dataSize > 0 ? pngData : nil
    }
    
    private func presentTextField(
        title: String,
        text: String? = nil,
        cancelTitle: String = "Cancel",
        completion: @escaping (_ text: String) -> Void, cancel: @escaping () -> Void
        ) {
        
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField { (tf) in
            tf.text = text
            tf.addTarget(self, action: #selector(self.tfaTextFieldEditingChanged), for: .editingChanged)
        }
        
        self.inputTFAText = text ?? ""
        alert.addAction(UIAlertAction(
            title: "Done",
            style: .default,
            handler: { _ in
                completion(self.inputTFAText)
        }))
        
        alert.addAction(UIAlertAction(
            title: cancelTitle,
            style: .cancel,
            handler: { _ in
                cancel()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showError(title: String = "Error", _ error: Swift.Error) {
        let localizedDescription = error.localizedDescription
        
        let alert = UIAlertController(
            title: title,
            message: localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addTextField { (tf) in
            tf.text = localizedDescription
        }
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in
                
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showMessage(title: String = "Result", _ message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addTextField { (tf) in
            tf.text = message
        }
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in
                
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tfaTextFieldEditingChanged(_ tf: UITextField) {
        self.inputTFAText = tf.text ?? ""
    }
}

//extension ApiExampleViewControllerV3: UIDocumentPickerDelegate {
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let url = urls.first else {
//            return
//        }
//
//        self.requestPolicyAndUpload(documentUrl: url)
//    }
//}

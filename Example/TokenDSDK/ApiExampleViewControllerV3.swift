import UIKit
import TokenDSDK
import DLCryptoKit
import TokenDWallet
import DLJSONAPI
import SnapKit

// swiftlint:disable line_length
class ApiExampleViewControllerV3: UIViewController, RequestSignKeyDataProviderProtocol {
    
    var privateKey: ECDSA.KeyData?
    
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
    
    lazy var apiConfig: ApiConfiguration = {
        return ApiConfiguration(
            urlString: Constants.apiUrlString
        )
    }()
    
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
            configuration: self.apiConfig,
            callbacks: self.apiCallbacks,
            network: self.network,
            requestSigner: JSONAPI.RequestSigner(keyDataProvider: self.vc)
        )
        return api
    }()
    
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
        
    }
    
    // MARK: -
    
    func requestAccount() {
        self.tokenDApi.accountsApi.requestAccount(
            accountId: "GBLTOG6EJS5OWDNQNSCEAVDNMPBY6F73XZHHKR27YE5AKE23ZZEXOLBK",
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    self?.showError(error)
                    
                case .success(let document):
                    print("account document: \(document)")
                }
        })
    }
    
    func loginAndRequestHistoryForFirstBalance() {
        self.vc.performLogin(onSuccess: { (walledData) in
            self.vc.tokenDApi.balancesApi.requestDetails(
                accountId: walledData.accountId,
                completion: { (result) in
                    switch result {
                        
                    case .failure(let errors):
                        print("failed to fetch balances: \(errors.localizedDescription)")
                        
                    case .success(let balances):
                        guard let balance = balances.first else {
                            print("No balances")
                            return
                        }
                        
                        self.requestHistory(
                            balance: balance.balanceId,
                            completion: { (document) in
                                guard let data = document.data else {
                                    print("failed to get data: \(document)")
                                    return
                                }
                                
                                print("history: \(data)")
                        })
                    }
            })
        })
    }
    
    func requestHistory(
        balance: String,
        completion: @escaping (_ doc: Document<[ParticipantEffectResource]>) -> Void
        ) {
        
        let filters = HistoryRequestFiltersV3.with(
            .balance(balance)
        )
        
        let pagination = RequestPagination(.single(index: 0, limit: 20, order: .descending))
        
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
    
    func requestMoreHistory(balance: String) {
        let filters = HistoryRequestFiltersV3.with(
            .balance(balance)
        )
        
        let pagination = RequestPagination(.single(index: 0, limit: 3, order: .descending))
        
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
                        ParticipantEffectResource.self,
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
    
    private var loadAllAssetsController: LoadAllResourcesController<AssetResource>?
    func requestAssetsV3() {
        let paginationStrategy = IndexedPaginationStrategy(index: nil, limit: 2, order: .ascending)
        self.loadAllAssetsController = LoadAllResourcesController(
            requestPagination: RequestPagination(.strategy(paginationStrategy))
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
        let parameters = OrderBookRequestFiltersV3
            .with(.baseAsset("BTC"))
            .addFilter(.quoteAsset("USD"))
            .addFilter(.isBuy(true))
        
        self.tokenDApi.orderBookApi.requestOffers(
            orderBookId: "0",
            filters: parameters,
            pagination: RequestPagination(.single(index: 0, limit: 10, order: .descending)),
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
        
        let pagination = RequestPagination(.single(index: 0, limit: 10, order: .ascending))
        
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
// swiftlint:enable line_length

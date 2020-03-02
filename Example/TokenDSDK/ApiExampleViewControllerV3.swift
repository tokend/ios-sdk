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
class ApiExampleViewControllerV3: UIViewController, RequestSignKeyDataProviderProtocol {
    
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
            requestSigner: JSONAPI.RequestSigner(keyDataProvider: self)
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
        self.setTelegram()
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
    
    func getPhoneByAccountId() {
        self.vc.tokenDApi.generalApi.requestIdentities(
            filter: .accountId(Constants.userAccountId),
            completion: { result in
                switch result {
                    
                case .failed(let error):
                    print("error: \(error)")
                    
                case .succeeded(let identities):
                    guard let number = identities.first(where: { (identity) -> Bool in
                        return identity.attributes.phoneNumber != nil
                    })?.attributes.phoneNumber else {
                        return
                    }
                    print(number)
                }
        })
    }
    
    func setPhone() {
        self.vc.tokenDApi
            .generalApi
            .requestSetPhone(
                accountId: Constants.userAccountId,
                phone: .init(phone: "+88005553535"),
                completion: { (result) in
                    switch result {
                        
                    case .failed(let error):
                        if error.contains(status: "403") {
                            
                        }
                        
                    case .succeeded:
                        print("Success")
                        
                    case .tfaFailed:
                        print("TFA Failed")
                    }
            }
        )
    }
    
    func setTelegram() {
        self.vc.tokenDApi
            .generalApi
            .requestSetTelegram(
                accountId: Constants.userAccountId,
                telegram: .init(username: "username"),
                completion: { (result) in
                    switch result {
                        
                    case .failed(let error):
                        if error.contains(status: "403") {
                            
                        }
                        
                    case .succeeded:
                        print("Success")
                        
                    case .tfaFailed:
                        print("TFA Failed")
                    }
            }
        )
    }
    
    func sendFiatPayment() {
        self.vc.transactionsApi.sendFiatPayment(
            envelope: "AAAAAKbDjaev91h/pGho2pP/H0bmS6zQemCK/NBnvugPSv6FA7OCxl9K5RMAAAAAXVZiuQAAAABdX48pAAAAAAAAAAEAAAAAAAAAJQAAAAAAAAAMAAAAAABMS0AAAAADVUFIAAAAAAAAAAAAAAAAAAAAAAAAAAABD0r+hQAAAEBNuuXNsMBEPkjzWmJ5R4zsKq8fnW7hyJo4sqZTqW9xZyC37B6PxGx1PrSA1SN8um99nThzVC8Kv0NuT7chD4ID",
            completion: { (result) in
                switch result {
                case .failure(let error):
                    print("Error: \(error)")
                    
                case .success(let resposnse):
                    print("Success: \(resposnse.data.attributes.payUrl)")
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
    
    func requestAtomicSwapAsks() {
        let filters = AtomicSwapFiltersV3.with(.baseAsset("82745DB9210D4AD4"))
        
        let pagination = RequestPagination(.single(index: 0, limit: 20, order: .descending))
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
        
        let pagination = RequestPagination(.single(index: 0, limit: 20, order: .descending))
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
        let pagination = RequestPagination(.single(index: 0, limit: 20, order: .descending))
        
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
        let single = RequestPagination.Option.single(
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
    
    private var loadAllVotesController: LoadAllResourcesController<VoteResource>?
    func requestVotes() {
        let strategy = IndexedPaginationStrategy(
            index: nil,
            limit: 1,
            order: .descending
        )
        let pagination = RequestPagination( .strategy(strategy))
        self.loadAllVotesController = LoadAllResourcesController<VoteResource>(
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
    
    func loginAndRequestHistoryForFirstBalance() {
        self.vc.performLogin(
            onSuccess: { (walledData) in
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
        },
            onFailed: { _ in }
        )
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
    
    func requestMovements(
        account: String,
        completion: @escaping (_ doc: Document<[ParticipantEffectResource]>) -> Void
        ) {
        
        let filters = MovementsRequestFilterV3.with(
            .account(account)
        )
        
        let pagination = RequestPagination(.single(index: 0, limit: 20, order: .descending))
        
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
    
    func requestKeyValueEntries() {
        let pagination = IndexedPaginationStrategy(index: nil, limit: 100, order: .ascending)
        
        self.tokenDApi.keyValuesApi.requestKeyValueEntries(
            pagination: RequestPagination(.strategy(pagination)),
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
        
        vc.delegate = self
        
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
    
    func requestPolicyAndUpload(uploadOption: UploadOption) {
        let image: UIImage
        
        switch uploadOption {
            
        case .image(let img):
            image = img
            
        case .imageUrl(let url):
            guard
                let data = try? Data(contentsOf: url),
                let img = UIImage(data: data) else {
                    return
            }
            
            image = img
        }
        
        guard let data = self.resizeImageToMaxSizePNGData(image: image) else {
            return
        }
        
        let documentUploadOption = DocumentUploadOption.data(
            data: data,
            meta: DocumentUploadOption.MetaInfo(
                fileName: "\(Date()).png",
                mimeType: UploadPolicy.ContentType.imagePng
            )
        )
        let policyType = UploadPolicy.PolicyType.generalPublic
        let contentType = UploadPolicy.ContentType.imagePng
        
        self.vc.requestUploadPolicy(
            policyType: policyType,
            contentType: contentType,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    print("Failed to request policy: \(errors.localizedDescription)")
                    
                case .success(let response):
                    self.uploadDocument(uploadPolicy: response, documentUploadOption: documentUploadOption)
                }
        })
    }
    
    func uploadDocument(
        uploadPolicy: GetUploadPolicyResponse,
        documentUploadOption: DocumentUploadOption
        ) {
        
        _ = self.vc.tokenDApi.documentsApi.uploadDocument(
            uploadPolicy: uploadPolicy,
            uploadOption: documentUploadOption,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    print("Failed to upload file: \(error)")
                    
                case .success:
                    print("File uploaded")
                    self.requestDocumentUrl(documentId: uploadPolicy.documentId)
                }
        })
    }
    
    func requestDocumentUrl(documentId: String) {
        self.vc.requestDocumentUrl(
            documentId: documentId,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    print("Get document url error: \(error.localizedDescription)")
                    
                case .success(let response):
                    print("Get document url: \(response.attributes.url)")
                }
        })
    }
    
    func requestChangeRoleRequests() {
        let filters = ChangeRoleRequestsFiltersV3.with(.requestor(self.vc.accountId))
        let pagination = RequestPagination(.strategy(IndexedPaginationStrategy(
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

extension ApiExampleViewControllerV3: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if #available(iOS 11.0, *) {
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                self.requestPolicyAndUpload(uploadOption: .imageUrl(url))
            } else if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.requestPolicyAndUpload(uploadOption: .image(image))
            } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.requestPolicyAndUpload(uploadOption: .image(image))
            }
        } else {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.requestPolicyAndUpload(uploadOption: .image(image))
            } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.requestPolicyAndUpload(uploadOption: .image(image))
            }
        }
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable line_length
// swiftlint:enable file_length

import UIKit
import CoreServices
import DLCryptoKit
import DLJSONAPI
import RxCocoa
import RxSwift
import SnapKit
import TokenDSDK
import TokenDWallet

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
        self.requestOrderBookV3()
    }
    
    // MARK: -
    
    func requestAccount() {
        self.tokenDApi.accountsApi.requestAccount(
            accountId: "GDD4FBEFMHJ2CCEX64CY5743T2JSZKOWQMTCGFVJKTHUJMD6ASG6H2VU",
            include: ["balances", "balances.asset"],
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
// swiftlint:enable line_length

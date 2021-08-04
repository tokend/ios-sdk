import UIKit
import TokenDSDK
import DLCryptoKit
import TokenDWallet
import DLJSONAPI
import SnapKit

// swiftlint:disable file_length type_body_length force_try line_length
class ApiExampleViewController: UIViewController, RequestSignKeyDataProviderProtocol, RequestSignAccountIdProviderProtocol {
    
    var privateKey: ECDSA.KeyData? = try? ECDSA.KeyData(
        seed: try! Base32Check.decodeCheck(
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
    
    var walletData: WalletDataModel?
    
    lazy var apiCallbacks: ApiCallbacks = {
        return ApiCallbacks(
            onTFARequired: { [weak self] (input, cancel) in },
            onUnathorizedRequest: { (error) in
                print("on unauthorized: \(error.localizedDescription)")
        })
    }()
    
    lazy var alamofireNetwork: AlamofireNetwork = {
        return AlamofireNetwork(
            userAgent: "agent",
            onUnathorizedRequest: self.apiCallbacks.onUnathorizedRequest
        )
    }()
    var network: NetworkProtocol {
        return self.alamofireNetwork
    }
    
    lazy var apiCallbacksV3: JSONAPI.ApiCallbacks = {
        return JSONAPI.ApiCallbacks(
            onUnathorizedRequest: { (error) in
                print("on unauthorized: \(error.localizedDescription)")
        })
    }()
    
    lazy var alamofireNetworkV3: JSONAPI.AlamofireNetwork = {
        return JSONAPI.AlamofireNetwork(
            resourcePool: ResourcePool(queue: DispatchQueue(label: "test")),
            onUnathorizedRequest: self.apiCallbacksV3.onUnathorizedRequest
        )
    }()
    var networkV3: JSONAPI.NetworkProtocol {
        return self.alamofireNetworkV3
    }
    
    lazy var verifyApi: TokenDSDK.TFAVerifyApi = {
        let api = TokenDSDK.TFAVerifyApi(
            apiConfiguration: self.apiConfig,
            requestSigner: RequestSigner(keyDataProvider: self, accountIdProvider: self),
            network: self.network
        )
        return api
    }()
    
    lazy var tokenDApi: TokenDSDK.API = {
        let api = TokenDSDK.API(
            configuration: self.apiConfig,
            callbacks: self.apiCallbacks,
            network: self.network,
            requestSigner: RequestSigner(keyDataProvider: self, accountIdProvider: self)
        )
        return api
    }()
    
    lazy var keyServerApi: TokenDSDK.KeyServerApi = {
        let api = TokenDSDK.KeyServerApi(
            apiConfigurationProvider: self.apiConfig,
            callbacks: self.apiCallbacks,
            verifyApi: self.verifyApi,
            requestSigner: JSONAPI.RequestSigner(keyDataProvider: self, accountIdProvider: self),
            network: self.network,
            networkV3: self.networkV3
        )
        return api
    }()
    
    var accountId: String {
        return self.walletData!.accountId
    }
    
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
    
    @objc func runTest() { }
    
    // MARK: -
    
    func getFactors(walletId: String) {
        self.tokenDApi.tfaApi.getFactors(
            walletId: walletId,
            completion: { (result: Swift.Result) in
                switch result {
                    
                case .failure(let errors):
                    print("\(#function) - failure: \(errors)")
                    self.showError(title: "Get Factors", errors)
                    
                case .success(let factors):
                    print("\(#function) - success: \(factors)")
                    
                    self.setTFAEnabled(!factors.isTOTPEnabled(), walletId: walletId)
                }
        })
    }
    
    func setTFAEnabled(_ enabled: Bool, walletId: String) {
        self.deleteTOTPFactors(
            walletId: walletId,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure:
                    print("\(#function) - failure")
                    
                case .success:
                    print("\(#function) - success")
                    
                    if enabled {
                        self?.enableTOTPFactor(walletId: walletId)
                    }
                }
        })
    }
    
    func enableTOTPFactor(walletId: String) {
        let createFactor: (_ priority: Int) -> Void = { (priority) in
            self.tokenDApi.tfaApi.createFactor(
                walletId: walletId,
                type: TFAFactorType.totp.rawValue,
                completion: { (result: Swift.Result) in
                    switch result {
                        
                    case .failure(let error):
                        print("\(#function) - createFactor failure: \(error)")
                        
                    case .success(let response):
                        print("\(#function) - createFactor success: \(response)")
                        
                        self.showTOTPSetupDialog(response: response, walletId: walletId, priority: priority)
                    }
            })
        }
        
        self.tokenDApi.tfaApi.getFactors(
            walletId: walletId,
            completion: { (result: Swift.Result) in
                switch result {
                    
                case .failure(let errors):
                    print("\(#function) - getFactors failure: \(errors)")
                    
                case .success(let factors):
                    print("\(#function) - getFactors success: \(factors)")
                    
                    let priority = factors.getHighestPriority(factorType: nil) + 1
                    createFactor(priority)
                }
        })
    }
    
    func updateTOTPFactor(walletId: String, factorId: Int, priority: Int) {
        self.tokenDApi.tfaApi.updateFactor(
            walletId: walletId,
            factorId: factorId,
            priority: priority,
            completion: { (result: Swift.Result) in
                switch result {
                    
                case .failure(let error):
                    print("\(#function) - updateFactor failure: \(error)")
                    
                case .success:
                    print("\(#function) - updateFactor success")
                }
        })
    }
    
    enum DeleteTOTPFactorsResult {
        case failure
        case success
    }
    func deleteTOTPFactors(
        walletId: String,
        completion: @escaping (_ result: DeleteTOTPFactorsResult) -> Void
        ) {
        
        self.tokenDApi.tfaApi.getFactors(
            walletId: walletId,
            completion: { (result: Swift.Result) in
                switch result {
                    
                case .failure(let errors):
                    print("\(#function) - failure: \(errors)")
                    completion(.failure)
                    
                case .success(let factors):
                    print("\(#function) - success: \(factors)")
                    
                    let totpFactors = factors.getTOTPFactors()
                    if let totpFactor = totpFactors.first {
                        guard let id = Int(totpFactor.id) else {
                            return
                        }
                        self.tokenDApi.tfaApi.deleteFactor(
                            walletId: walletId,
                            factorId: id,
                            completion: { (deleteResult: Swift.Result) in
                                switch deleteResult {
                                    
                                case .failure(let error):
                                    print("\(#function) - delete failure: \(error)")
                                    
                                case .success:
                                    self.deleteTOTPFactors(walletId: walletId, completion: completion)
                                }
                        })
                    } else {
                        completion(.success)
                    }
                }
        })
    }
    
    func redirectAlert(
        title: String,
        actionTitle: String,
        url: URL,
        completion: @escaping (_ text: String) -> Void,
        cancel: @escaping () -> Void
        ) {
        
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: actionTitle,
            style: .default,
            handler: { _ in
                UIApplication.shared.open(
                    url,
                    options: [:],
                    completionHandler: { [weak self] (_) in
                        self?.presentTextField(
                            title: "Input tfa code",
                            completion: completion,
                            cancel: cancel
                        )
                })
        })
        alert.addAction(action)
        if let parent = self.parent {
            parent.present(alert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentTextField(
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
        
        if let parent = self.parent {
            parent.present(alert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showRecoverySeedAlert(seedBase32Check: String, completion: @escaping (() -> Void)) {
        let alert = UIAlertController(
            title: "Save Recovery Seed",
            message: seedBase32Check,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Copy",
            style: .default,
            handler: { _ in
                UIPasteboard.general.string = seedBase32Check
                
                completion()
        }))
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in
                completion()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showTOTPSetupDialog(response: TFACreateFactorResponse, walletId: String, priority: Int) {
        let alert = UIAlertController(
            title: "Set up 2FA",
            message: "To enable Two-factor authentication open Google Authenticator or similar app with the button below or copy and manually enter this key:\n\n\(response.attributes.secret)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Copy",
            style: .default,
            handler: { _ in
                UIPasteboard.general.string = response.attributes.secret
                guard let id = Int(response.id) else {
                    return
                }
                self.updateTOTPFactor(walletId: walletId, factorId: id, priority: priority)
        }))
        
        if let url = URL(string: response.attributes.seed),
            UIApplication.shared.canOpenURL(url) {
            alert.addAction(UIAlertAction(
                title: "Open App",
                style: .default,
                handler: { _ in
                    UIPasteboard.general.string = response.attributes.secret
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    guard let id = Int(response.id) else {
                        return
                    }
                    self.updateTOTPFactor(walletId: walletId, factorId: id, priority: priority)
            }))
        }
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in
                
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(title: String = "Error", _ error: Swift.Error) {
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
    
    func showMessage(title: String = "Result", _ message: String) {
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
    
    // MARK: -
    
    @objc func tfaTextFieldEditingChanged(_ tf: UITextField) {
        self.inputTFAText = tf.text ?? ""
    }
}
// swiftlint:enable file_length type_body_length force_try line_length

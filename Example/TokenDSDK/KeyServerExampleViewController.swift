import UIKit
import TokenDSDK
import DLCryptoKit
import TokenDWallet
import DLJSONAPI

// swiftlint:disable type_body_length line_length
class KeyServerExampleViewController: UIViewController, RequestSignKeyDataProviderProtocol {
    
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
    
    var walletData: WalletDataModel?
    
    lazy var apiCallbacks: ApiCallbacks = {
        return ApiCallbacks(
            onTFARequired: { [weak self] (input, cancel) in
                self?.initiateTFA(input: input, cancel: cancel)
            },
            onUnathorizedRequest: { (error) in
                print("on unauthorized: \(error.localizedDescription)")
        })
    }()
    
    lazy var apiCallbacksV3: JSONAPI.ApiCallbacks = {
        return JSONAPI.ApiCallbacks(
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
    
    lazy var alamofireNetworkV3: JSONAPI.AlamofireNetwork = {
        return JSONAPI.AlamofireNetwork(
            resourcePool: ResourcePool(queue: DispatchQueue(label: "test")),
            onUnathorizedRequest: self.apiCallbacksV3.onUnathorizedRequest
        )
    }()
    var networkV3: JSONAPI.NetworkProtocol {
        return self.alamofireNetworkV3
    }
    
    lazy var tfaApi: TokenDSDK.TFAApi = {
        let api = TFAApi(
            apiConfiguration: self.apiConfig,
            requestSigner: RequestSigner(keyDataProvider: self),
            callbacks: self.apiCallbacks,
            network: self.network
        )
        return api
    }()
    
    lazy var verifyApi: TokenDSDK.TFAVerifyApi = {
        let api = TokenDSDK.TFAVerifyApi(
            apiConfiguration: self.apiConfig,
            requestSigner: RequestSigner(keyDataProvider: self),
            network: self.network
        )
        return api
    }()
    
    lazy var keyServerApi: TokenDSDK.KeyServerApi = {
        let api = TokenDSDK.KeyServerApi(
            apiConfiguration: self.apiConfig,
            callbacks: self.apiCallbacks,
            verifyApi: self.verifyApi,
            requestSigner: JSONAPI.RequestSigner(keyDataProvider: self),
            network: self.network,
            networkV3: self.networkV3
        )
        return api
    }()
    
    lazy var generalApi: TokenDSDK.GeneralApi = {
        let api = GeneralApi(
            apiStack: BaseApiStack(
            apiConfiguration: self.apiConfig,
            callbacks: self.apiCallbacks,
            network: self.network,
            requestSigner: RequestSigner(keyDataProvider: self),
            verifyApi: self.verifyApi
        )
        )
        return api
    }()
    
    lazy var accountApi: TokenDSDK.AccountsApi = {
        let api = TokenDSDK.AccountsApi(
            apiStack: BaseApiStack(
                apiConfiguration: self.apiConfig,
                callbacks: self.apiCallbacks,
                network: self.network,
                requestSigner: RequestSigner(keyDataProvider: self),
                verifyApi: self.verifyApi
            )
        )
        return api
    }()
    
    var accountId: String {
        return self.walletData!.accountId
    }
    
    var inputTFAText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.alamofireNetwork.startLogger()
        
        self.performLogin { _ in
            
        }
    }
    
    // MARK: -
    
    func register() {
        self.presentTextField(
            title: "Email",
            text: Constants.userEmail,
            completion: { (email) in
                
                self.presentTextField(
                    title: "Password",
                    text: Constants.userPassword,
                    completion: { (password) in
                        
                        self.registerWith(email: email, password: password)
                },
                    cancel: {}
                )
        },
            cancel: {}
        )
    }
    
    func recoverAccount() {
        self.presentTextField(
            title: "Recovery - Email",
            text: Constants.userEmail,
            completion: { (email) in
                
                self.presentTextField(
                    title: "Recovery - Seed",
                    text: Constants.recoverySeed,
                    completion: { (seed) in
                        
                        self.presentTextField(
                            title: "Recovery - New Password",
                            text: Constants.userPassword,
                            completion: { (newPassword) in
                                guard let newKeyPair = try? ECDSA.KeyData() else {
                                    return
                                }
                                
                                self.recoverAccountWith(
                                    email: email,
                                    recoverySeed: seed,
                                    newPassword: newPassword,
                                    newKeyPair: newKeyPair
                                )
                        },
                            cancel: {}
                        )
                },
                    cancel: {}
                )
        },
            cancel: {}
        )
    }
    
    func changePassword() {
        self.presentTextField(
            title: "Change Password - Email",
            text: Constants.userEmail,
            completion: { (email) in
                
                self.presentTextField(
                    title: "Change Password - Old Password",
                    text: Constants.userPassword,
                    completion: { (oldPassword) in
                        
                        self.presentTextField(
                            title: "Change Password - New Password",
                            text: "qwe123",
                            completion: { (newPassword) in
                                guard let newKeyPair = try? ECDSA.KeyData() else {
                                    return
                                }
                                
                                self.changePassword(
                                    email: email,
                                    oldPassword: oldPassword,
                                    newPassword: newPassword,
                                    newKeyPair: newKeyPair
                                )
                        },
                            cancel: {}
                        )
                },
                    cancel: {}
                )
        },
            cancel: {}
        )
    }
    
    func registerWith(email: String, password: String) {
        let info: WalletInfoModel? = nil
        guard let walletInfo = info else {
            print("Wallet info is not set")
            return
        }
        
        self.keyServerApi.createWallet(
            walletInfo: walletInfo,
            completion: { [weak self] (result) in
                
                switch result {
                    
                case .failure(let error):
                    self?.showError(title: "Register", error)
                    
                case .success(let walletInfoResponse):
                    print("info: \(walletInfoResponse)")
                    // TODO: !!!
//                    print("walletData: \(walletData)")
//                    print("key seed: \(Base32Check.encode(version: .seedEd25519, data: keyPair.getPrivateKeyData()))")
//                    Constants.userEmail = email
//                    Constants.userPassword = password
//                    let seedBase32Check = Base32Check.encode(version: .seedEd25519, data: recoveryKey.getSeedData())
//                    print("recovery seed: \(seedBase32Check)")
//                    Constants.recoverySeed = seedBase32Check
//                    self?.showRecoverySeedAlert(seedBase32Check: seedBase32Check, completion: {
//                        self?.performLogin { _ in
//
//                        }
//                    })
                }
        })
    }
    
    func recoverAccountWith(
        email: String,
        recoverySeed: String,
        newPassword: String,
        newKeyPair: ECDSA.KeyData
        ) {
        
        self.generalApi.requestNetworkInfo(completion: { [weak self] (result) in
            switch result {
                
            case .failed(let error):
                self?.showError(error)
                
            case .succeeded(let networkInfo):
                print("networkInfo: \(networkInfo)")
                // TODO: !!!
//                let onSignRequest = RequestSignerBlockCaller.getUnsafeSignRequestBlock()
//
//                _ = self?.keyServerApi.recoverWallet(
//                    email: email,
//                    recoverySeedBase32Check: recoverySeed,
//                    newPassword: newPassword,
//                    newKeyPair: newKeyPair,
//                    passwordFactorKeyPair: nil,
//                    onSignRequest: onSignRequest,
//                    networkInfo: networkInfo,
//                    completion: { (result) in
//                        switch result {
//
//                        case .failed(let error):
//                            self?.showError(error)
//
//                        case .succeeded(_, _, let newKey):
//                            let seed = Base32Check.encode(version: .seedEd25519, data: newKey.getSeedData())
//                            print("Changed key seed: \(seed)")
//                            Constants.userPassword = newPassword
//                            self?.performLogin { _ in
//
//                            }
//                        }
//                })
            }
        })
    }
    
    func changePassword(
        email: String,
        oldPassword: String,
        newPassword: String,
        newKeyPair: ECDSA.KeyData
        ) {
        
        self.generalApi.requestNetworkInfo(completion: { [weak self] (result) in
            switch result {
                
            case .failed(let error):
                self?.showError(error)
                
            case .succeeded(let networkInfo):
                print("networkInfo: \(networkInfo)")
                // TODO: !!!
//                let onSignRequest = RequestSignerBlockCaller.getUnsafeSignRequestBlock()
//
//                _ = self?.keyServerApi.changeWalletPassword(
//                    email: email,
//                    oldPassword: oldPassword,
//                    newPassword: newPassword,
//                    newKeyPair: newKeyPair,
//                    onSignRequest: onSignRequest,
//                    passwordFactorKeyPair: nil,
//                    networkInfo: networkInfo,
//                    completion: { (result) in
//                        switch result {
//
//                        case .failed(let error):
//                            self?.showError(error)
//
//                        case .succeeded(_, _, let newKey):
//                            let seed = Base32Check.encode(version: .seedEd25519, data: newKey.getSeedData())
//                            print("Changed key seed: \(seed)")
//                            Constants.userPassword = newPassword
//                            self?.performLogin { _ in
//
//                            }
//                        }
//                })
            }
        })
    }
    
    func performLogin(onSuccess: @escaping (_ walletData: WalletDataModel) -> Void) {
//        self.keyServerApi.loginWith(
//            login: Constants.userEmail,
//            password: Constants.userPassword,
//            completion: { [weak self] result in
//                switch result {
//
//                case .success(let walletData, let keyPair):
//                    let seed = Base32Check.encode(version: .seedEd25519, data: keyPair.getSeedData())
//                    print("Login key seed: \(seed)")
//                    self?.privateKey = keyPair
//                    self?.walletData = walletData
//
//                    onSuccess(walletData)
//
//                case .failure(let error):
//                    self?.showError(title: "Login", error)
//                }
//        })
    }
    
    func requestAccount() {
        self.accountApi.requestAccount(
            accountId: self.accountId,
            completion: { [weak self] (result) in
                switch result {
                case .success:
                    print("\(#function) - success")
                case .failure(let error):
                    self?.showError(error)
                }
                
                self?.requestSigners()
        })
    }
    
    func requestAccountIdForEmail(_ email: String) {
        self.generalApi.requestIdentities(
        filter: .email(email)) { [weak self] (result) in
            switch result {
            case .succeeded:
                print("\(#function) - success")
            case .failed(let error):
                self?.showError(error)
            }
        }
    }
    
    func requestSigners() {
        self.accountApi.requestSigners(
            accountId: self.accountId,
            completion: { [weak self] (result) in
                switch result {
                case .success:
                    print("\(#function) - success")
                case .failure(let error):
                    self?.showError(error)
                }
        })
    }
    
    func requestNetworkInfo() {
        self.generalApi.requestNetworkInfo { [weak self] (result) in
            switch result {
            case .succeeded(let info):
                print("\(#function) - success: \(info)")
            case .failed(let error):
                self?.showError(error)
            }
        }
    }
    
    private func getFactors(walletId: String) {
        self.tfaApi.getFactors(
            walletId: walletId,
            completion: { (result) in
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
    
    private func setTFAEnabled(_ enabled: Bool, walletId: String) {
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
    
    private func enableTOTPFactor(walletId: String) {
        let createFactor: (_ priority: Int) -> Void = { (priority) in
            self.tfaApi.createFactor(
                walletId: walletId,
                type: TFAFactorType.totp.rawValue,
                completion: { (result) in
                    switch result {
                        
                    case .failure(let error):
                        print("\(#function) - createFactor failure: \(error)")
                        
                    case .success(let response):
                        print("\(#function) - createFactor success: \(response)")
                        
                        self.showTOTPSetupDialog(response: response, walletId: walletId, priority: priority)
                    }
            })
        }
        
        self.tfaApi.getFactors(
            walletId: walletId,
            completion: { (result) in
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
    
    private func updateTOTPFactor(walletId: String, factorId: Int, priority: Int) {
        self.tfaApi.updateFactor(
            walletId: walletId,
            factorId: factorId,
            priority: priority,
            completion: { result in
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
    private func deleteTOTPFactors(
        walletId: String,
        completion: @escaping (_ result: DeleteTOTPFactorsResult) -> Void
        ) {
        
        self.tfaApi.getFactors(
            walletId: walletId,
            completion: { (result) in
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
                        self.tfaApi.deleteFactor(
                            walletId: walletId,
                            factorId: id,
                            completion: { (deleteResult) in
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
    
    // MARK: - TFA
    
    private func initiateTFA(input: ApiCallbacks.TFAInput, cancel: @escaping () -> Void) {
        let alertTitle: String
        switch input {
            
        case .password:
            alertTitle = "Input password"
            
        case .code(let type, _):
            switch type {
                
            case .email:
                alertTitle = "Input Code from Email"
                
            case .phone:
                alertTitle = "Input Code from SMS"
                
            case .totp:
                alertTitle = "Input Code from Authenticator"
                
            case .other(let other):
                alertTitle = "Input Code from \(other)"
                
            case .telegram(let url):
                alertTitle = "Input Code from \(url)"
            }
        }
        
        self.presentTextField(title: alertTitle, completion: { [weak self] (text) in
            switch input {
                
            case .password(let tokenSignData, let inputCallback):
                self?.processInput(
                    password: text,
                    tokenSignData: tokenSignData,
                    inputCallback: inputCallback,
                    cancel: cancel
                )
                
            case .code(_, let inputCallback):
                inputCallback(text, { })
            }
            }, cancel: {
                cancel()
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
    
    private func processInput(
        password: String,
        tokenSignData: ApiCallbacks.TokenSignData,
        inputCallback: @escaping (_ signedToken: String, _ completion: @escaping () -> Void) -> Void,
        cancel: @escaping () -> Void
        ) {
        
        self.keyServerApi.requestWalletKDF(
            login: Constants.userEmail,
            completion: { result in
                switch result {
                    
                case .failure(let error):
                    print("Unable to sign TFA token with password: \(error)")
                    cancel()
                    
                case .success(let walletKDF):
                    guard
                        let signedToken = self.getSignedTokenForPassword(
                            password,
                            walletId: tokenSignData.walletId,
                            keychainData: tokenSignData.keychainData,
                            email: Constants.userEmail,
                            token: tokenSignData.token,
                            factorId: tokenSignData.factorId,
                            walletKDF: WalletKDFParams(
                                kdfParams: walletKDF.kdfParams,
                                salt: tokenSignData.salt
                            )
                        ) else {
                            print("Unable to sign TFA token with password")
                            cancel()
                            return
                    }
                    inputCallback(signedToken, { })
                }
        })
    }
    
    private func showRecoverySeedAlert(seedBase32Check: String, completion: @escaping (() -> Void)) {
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
    
    private func showTOTPSetupDialog(response: TFACreateFactorResponse, walletId: String, priority: Int) {
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
    
    public func getSignedTokenForPassword(
        _ password: String,
        walletId: String,
        keychainData: Data,
        email: String,
        token: String,
        factorId: Int,
        walletKDF: WalletKDFParams
        ) -> String? {

        return nil
//        guard
//            let keyPair = try? KeyPairBuilder.getKeyPair(
//                forLogin: email,
//                password: password,
//                keychainData: keychainData,
//                walletKDF: walletKDF
//            ) else {
//                print("Unable to get keychainData or create key pair")
//                return nil
//        }
//
//        guard let data = token.data(using: .utf8) else {
//            print("Unable to encode token to data")
//            return nil
//        }
//
//        guard let signedToken = try? ECDSA.signED25519(data: data, keyData: keyPair).base64EncodedString() else {
//            print("Unable to sign token data")
//            return nil
//        }
//
//        return signedToken
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
    
    // MARK: -
    
    @objc func tfaTextFieldEditingChanged(_ tf: UITextField) {
        self.inputTFAText = tf.text ?? ""
    }
}
// swiftlint:enable type_body_length line_length

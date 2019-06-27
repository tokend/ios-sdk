import UIKit
import TokenDSDK
import DLCryptoKit
import TokenDWallet
import DLJSONAPI
import SnapKit

// swiftlint:disable file_length type_body_length force_try line_length
class ApiExampleViewController: UIViewController, RequestSignKeyDataProviderProtocol {
    
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
            requestSigner: RequestSigner(keyDataProvider: self),
            network: self.network
        )
        return api
    }()
    
    lazy var tokenDApi: TokenDSDK.API = {
        let api = TokenDSDK.API(
            configuration: self.apiConfig,
            callbacks: self.apiCallbacks,
            network: self.network,
            requestSigner: RequestSigner(keyDataProvider: self)
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
    
    lazy var transactionsApi: TokenDSDK.TransactionsApi = {
        let api = TokenDSDK.TransactionsApi(
            apiStack: BaseApiStack(
                apiConfiguration: self.apiConfig,
                callbacks: self.apiCallbacks,
                network: self.tokenDApi.network,
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
                network: self.tokenDApi.network,
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
    
    func performLogin(
        onSuccess: @escaping (_ walletData: WalletDataModel) -> Void,
        onFailed: @escaping (_ error: KeyServerApi.LoginRequestResult.LoginError) -> Void
        ) {
        self.keyServerApi.loginWith(
            email: Constants.userEmail,
            password: Constants.userPassword,
            completion: { [weak self] result in
                switch result {
                    
                case .success(let walletData, let keyPair):
                    let seed = Base32Check.encode(version: .seedEd25519, data: keyPair.getSeedData())
                    print("Login key seed: \(seed)")
                    self?.privateKey = keyPair
                    self?.walletData = walletData
                    
                    onSuccess(walletData)
                    
                case .failure(let error):
                    onFailed(error)
                }
        })
    }
    
    func requestDefaultSignerRoleId() {
        self.keyServerApi.requestDefaultSignerRoleId(
            completion: { (result) in
                
                switch result {
                    
                case .failure(let error):
                    print("Default signer role id error: \(error.localizedDescription)")
                    
                case .success(let response):
                    print("default signer role id: \(response.roleId)")
                }
        })
    }
    
    func requestTrades() {
        self.tokenDApi.orderBookApi.requestTrades(
            parameters: TradesRequestParameters(
                baseAsset: "DLT10",
                quoteAsset: "EUR",
                orderBookId: "0"
            ),
            limit: 20,
            cursor: nil,
            completion: { [weak self] (result) in
                switch result {
                case .success:
                    print("\(#function) - success")
                case .failure(let error):
                    self?.showError(error)
                }
        })
    }
    
    func requestDetails() {
        self.tokenDApi.balancesApi.requestDetails(
            accountId: self.accountId,
            completion: { [weak self] result in
                switch result {
                case .success:
                    print("\(#function) - success")
                case .failure(let error):
                    self?.showError(error)
                }
                
                self?.requestPayments()
        })
    }
    
    func requestPayments() {
        let parameters = TransactionsPaymentsRequestParameters(
            asset: "BTC",
            cursor: nil,
            order: "desc",
            limit: 100,
            completedOnly: false
        )
        self.tokenDApi.transactionsApi.requestPayments(
            accountId: self.accountId,
            parameters: parameters,
            completion: { [weak self] result in
                switch result {
                case .success(let operations):
                    print("\(#function) - success - \(operations.count) operations")
                    
                case .failure(let error):
                    self?.showError(error)
                }
                
                self?.requestAssets()
        })
    }
    
    func requestOffers(isBuy: Bool? = nil, orderBookId: String = "0") {
        let parameters = OffersOffersRequestParameters(
            isBuy: isBuy,
            order: nil,
            baseAsset: nil,
            quoteAsset: nil,
            orderBookId: orderBookId,
            offerId: nil,
            other: nil
        )
        self.tokenDApi.offersApi.requestOffers(
            accountId: self.accountId,
            parameters: parameters) { [weak self] (result) in
                switch result {
                case .success(let offers):
                    print("\(#function) - success: \(offers)")
                case .failure(let error):
                    self?.showError(error)
                }
        }
    }
    
    func requestAssets() {
        self.tokenDApi.assetsApi.requestAssets(completion: { [weak self] (result) in
            switch result {
            case .success:
                print("\(#function) - success")
            case .failure(let error):
                self?.showError(error)
            }
            
            self?.requestAccount()
        })
    }
    
    func requestAssetPairs() {
        self.tokenDApi.assetPairsApi.requestAssetPairs(completion: { [weak self] (result) in
            switch result {
            case .success:
                print("\(#function) - success")
            case .failure(let error):
                self?.showError(error)
            }
        })
    }
    
    func requestAccount() {
        self.tokenDApi.accountsApi.requestAccount(
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
        self.tokenDApi.generalApi.requestIdentities(
            filter: .email(email)) { [weak self] (result) in
            switch result {
            case .succeeded:
                print("\(#function) - success")
            case .failed(let error):
                self?.showError(error)
            }
        }
    }
    
    func requestEmailForAccountId(_ accountId: String) {
        self.tokenDApi.generalApi.requestIdentities(
        filter: .accountId(accountId)) { [weak self] (result) in
            switch result {
            case .succeeded(let data):
                print(data)
                print("\(#function) - success")
            case .failed(let error):
                self?.showError(error)
            }
        }
    }
    
    func requestSigners() {
        self.tokenDApi.accountsApi.requestSigners(
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
        self.tokenDApi.generalApi.requestNetworkInfo { [weak self] (result) in
            switch result {
            case .succeeded(let info):
                print("\(#function) - success: \(info)")
            case .failed(let error):
                self?.showError(error)
            }
        }
    }
    
    func requestCharts() {
        self.tokenDApi.chartsApi.requestCharts(
            asset: "CTOKEN-ETH",
            completion: { [weak self] (result) in
                switch result {
                case .success:
                    print("\(#function) - success")
                case .failure(let error):
                    self?.showError(error)
                }
        })
    }
    
    func requestBalancesDetails() {
        self.tokenDApi.balancesApi.requestDetails(
            accountId: self.accountId,
            completion: { [weak self] (result) in
                switch result {
                case .success:
                    print("\(#function) - success")
                case.failure(let error):
                    self?.showError(error)
                }
        })
    }
    
    func requestUploadPolicy(
        policyType: String,
        contentType: String,
        completion: @escaping (_ result: DocumentsApi.GetUploadPolicyResult) -> Void
        ) {
        
        self.tokenDApi.documentsApi.requestUploadPolicy(
            accountId: self.accountId,
            policyType: policyType,
            contentType: contentType,
            completion: completion
        )
    }
    
    func requestDocumentUrl(
        documentId: String,
        completion: @escaping (_ result: DocumentsApi.GetDocumentURLResult) -> Void
        ) {
        
        self.tokenDApi.documentsApi.requestDocumentURL(
            accountId: self.accountId,
            documentId: documentId,
            completion: completion
        )
    }
    
    func sendTransaction(walletData: WalletDataModel, key: ECDSA.KeyData) {
        self.tokenDApi.generalApi.requestNetworkInfo(completion: { (result) in
            switch result {
                
            case .failed(let error):
                print("\(#function) - failure: \(error.localizedDescription)")
                
            case .succeeded(let networkInfo):
                self.tokenDApi.balancesApi.requestDetails(
                    accountId: walletData.accountId,
                    completion: { (result) in
                        switch result {
                            
                        case .failure(let errors):
                            print("\(#function) - failure: \(errors)")
                            
                        case .success(let balances):
                            if let balance = balances.first(where: { (balanceDetails) -> Bool in
                                return balanceDetails.asset == "BTC"
                            }) {
                                self.sendTransaction(
                                    networkInfo: networkInfo,
                                    walletData: walletData,
                                    key: key,
                                    sourceBalanceId: balance.balanceId,
                                    asset: balance.asset
                                )
                            } else {
                                for balance in balances where balance.balance > 0 {
                                    self.sendTransaction(
                                        networkInfo: networkInfo,
                                        walletData: walletData,
                                        key: key,
                                        sourceBalanceId: balance.balanceId,
                                        asset: balance.asset
                                    )
                                }
                            }
                        }
                })
            }
        })
    }
    
    func sendTransaction(
        networkInfo: NetworkInfoModel,
        walletData: WalletDataModel,
        key: ECDSA.KeyData,
        sourceBalanceId: String,
        asset: String
        ) {
        
        self.tokenDApi.generalApi.requestIdentities(
            filter: .email(Constants.sendTransactionDestinationEmail),
            completion: { result in
                switch result {
                    
                case .failed(let error):
                    print("\(#function) - failure: \(error)")
                    
                case .succeeded(let response):
                    guard let accountId = response.first?.attributes.address else {
                        print("Account with given email not found")
                        return
                    }
                    
                    self.sendTransaction(
                        networkInfo: networkInfo,
                        walletData: walletData,
                        key: key,
                        sourceBalanceId: sourceBalanceId,
                        asset: asset,
                        destinationAccountId: accountId
                    )
                }
        })
    }
    
    func sendTransaction(
        networkInfo: NetworkInfoModel,
        walletData: WalletDataModel,
        key: ECDSA.KeyData,
        sourceBalanceId: String,
        asset: String,
        destinationAccountId: String
        ) {
        
        let sourceFee = TokenDWallet.Fee(
            fixed: 0,
            percent: 0,
            ext: .emptyVersion()
        )
        let destinationFee = TokenDWallet.Fee(
            fixed: 0,
            percent: 0,
            ext: .emptyVersion()
        )
        
        let feeData = PaymentFeeData(
            sourceFee: sourceFee,
            destinationFee: destinationFee,
            sourcePaysForDest: true,
            ext: .emptyVersion()
        )
        
        let amount: Uint64 = 1000
        
        guard let sourceAccountID = AccountID(
            base32EncodedString: walletData.accountId,
            expectedVersion: .accountIdEd25519
            ) else {
                return
        }
        
        guard let sourceBalanceID = BalanceID(
            base32EncodedString: sourceBalanceId,
            expectedVersion: .balanceIdEd25519
            ) else {
                fatalError("fail to decode sourceBalanceId")
        }
        
        guard let destinationAccountID = AccountID(
            base32EncodedString: destinationAccountId,
            expectedVersion: .accountIdEd25519
            ) else {
                fatalError("fail to decode destinationAccountId")
        }
        
        let operation = PaymentOp(
            sourceBalanceID: sourceBalanceID,
            destination: .account(destinationAccountID),
            amount: amount,
            feeData: feeData,
            subject: "",
            reference: "",
            ext: .emptyVersion()
        )
        
        let sendDate = Date()
        let transactionBuilder: TransactionBuilder = TransactionBuilder(
            networkParams: networkInfo.networkParams,
            sourceAccountId: sourceAccountID,
            params: networkInfo.getTxBuilderParams(sendDate: sendDate)
        )
        
        transactionBuilder.add(
            operationBody: .payment(operation),
            operationSourceAccount: sourceAccountID
        )
        do {
            let transaction = try transactionBuilder.buildTransaction()
            
            try! transaction.addSignature(signer: key)
            
            self.transactionsApi.sendTransaction(
                envelope: transaction.getEnvelope().toXdrBase64String(),
                sendDate: sendDate,
                completion: { (result) in
                    switch result {
                        
                    case .failure(let error):
                        print("\(#function) - failure: \(error)")
                        
                    case .success:
                        print("\(#function) - success")
                    }
            })
        } catch let error {
            print("\(#function) - failure: \(error)")
        }
    }
    
    func getFactors(walletId: String) {
        self.tokenDApi.tfaApi.getFactors(
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
        
        self.tokenDApi.tfaApi.getFactors(
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
    
    func updateTOTPFactor(walletId: String, factorId: Int, priority: Int) {
        self.tokenDApi.tfaApi.updateFactor(
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
    func deleteTOTPFactors(
        walletId: String,
        completion: @escaping (_ result: DeleteTOTPFactorsResult) -> Void
        ) {
        
        self.tokenDApi.tfaApi.getFactors(
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
                        self.tokenDApi.tfaApi.deleteFactor(
                            walletId: walletId,
                            factorId: totpFactor.id,
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
    
    func requestSales(offersAsset: String? = nil, quoteAsset: String? = nil, feeAmount: Decimal? = nil) {
        self.tokenDApi.salesApi.getSales(
            SaleResponse.self,
            limit: 20,
            cursor: nil,
            page: nil,
            owner: nil,
            name: nil,
            baseAsset: nil,
            openOnly: nil,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    print("\(#function) - get sales failure: \(error)")
                    
                case .success(let sales):
                    if let offersAsset = offersAsset {
                        let farmSale = sales.first(where: { (sale) -> Bool in
                            return sale.baseAsset == offersAsset
                        })
                        guard let sale = farmSale else {
                            return
                        }
                        
                        if let quoteAsset = quoteAsset,
                            let quotedAsset = sale.quoteAssets.quoteAssets.first(where: { (quotedAsset) -> Bool in
                                quotedAsset.asset == quoteAsset
                            }) {
                            
                            self?.requestFee(asset: quotedAsset.asset, feeType: .offerFee, amount: feeAmount, subtype: 2)
                        } else {
                            self?.requestOffers(isBuy: true, orderBookId: sale.id)
                        }
                    }
                }
        })
    }
    
    func requestSaleDetails(saleId: String) {
        self.tokenDApi.salesApi.getSaleDetails(
            SaleDetailsResponse.self,
            saleId: saleId,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    print("\(#function) - sale details failure: \(error)")
                    
                case .success(let saleDetails):
                    print("\(#function) - sale details success: \(saleDetails)")
                    
                    self?.requestBlob(
                        accountId: saleDetails.ownerId,
                        blobId: saleDetails.details.description
                    )
                }
        })
    }
    
    func requestFee(asset: String, feeType: FeeResponse.FeeType, amount: Decimal?, subtype: Int32) {
        self.tokenDApi.generalApi.requestFee(
            accountId: self.accountId,
            asset: asset,
            feeType: feeType,
            amount: amount,
            subtype: subtype,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failed(let errors):
                    self?.showError(errors)
                    
                case .succeeded(let fee):
                    print("\(#function) - fee success: \(fee)")
                }
        })
    }
    
    func requestFeeOverview() {
        self.tokenDApi.generalApi.requestFeesOverview(
            completion: { [weak self] (result) in
                switch result {
                    
                case .failed(let errors):
                    self?.showError(errors)
                    
                case .succeeded(let feesOverview):
                    print("\(#function) - fee overview success: \(feesOverview)")
                }
        })
    }
    
    func requestBlob(
        accountId: String,
        blobId: String
        ) {
        
        self.accountApi.requestBlob(
            accountId: self.accountId,
            blobId: blobId,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    print("\(#function) - blob failure: \(error)")
                    
                case .success(let blob):
                    print("\(#function) - blob success: \(blob)")
                    print("blob content: \(blob.getBlobContent())")
                }
        })
    }
    
    // MARK: - TFA
    
    func initiateTFA(input: ApiCallbacks.TFAInput, cancel: @escaping () -> Void) {
        let alertTitle: String
        switch input {
            
        case .password:
            alertTitle = "Input password"
            
        case .code(let type, _):
            switch type {
                
            case .email:
                alertTitle = "Input Code from Email"
                
            case .totp:
                alertTitle = "Input Code from Authenticator"
                
            case .other(let other):
                alertTitle = "Input Code from \(other)"
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
                inputCallback(text)
            }
            }, cancel: {
                cancel()
        })
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
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func processInput(
        password: String,
        tokenSignData: ApiCallbacks.TokenSignData,
        inputCallback: @escaping (_ signedToken: String) -> Void,
        cancel: @escaping () -> Void
        ) {
        
        self.keyServerApi.requestWalletKDF(
            email: Constants.userEmail,
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
                    inputCallback(signedToken)
                }
        })
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
                
                self.updateTOTPFactor(walletId: walletId, factorId: response.id, priority: priority)
        }))
        
        if let url = URL(string: response.attributes.seed),
            UIApplication.shared.canOpenURL(url) {
            alert.addAction(UIAlertAction(
                title: "Open App",
                style: .default,
                handler: { _ in
                    UIPasteboard.general.string = response.attributes.secret
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                    self.updateTOTPFactor(walletId: walletId, factorId: response.id, priority: priority)
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
        
        guard
            let keyPair = try? KeyPairBuilder.getKeyPair(
                forEmail: email,
                password: password,
                keychainData: keychainData,
                walletKDF: walletKDF
            ) else {
                print("Unable to get keychainData or create key pair")
                return nil
        }
        
        guard let data = token.data(using: .utf8) else {
            print("Unable to encode token to data")
            return nil
        }
        
        guard let signedToken = try? ECDSA.signED25519(data: data, keyData: keyPair).base64EncodedString() else {
            print("Unable to sign token data")
            return nil
        }
        
        return signedToken
    }
    
    func requestDefaultKDF(completion: @escaping (KeyServerApi.RequestDefaultKDFResult) -> Void) {
        self.keyServerApi.requestDefaultKDF { (result) in
            switch result {
                
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let kdfParams):
                completion(.success(kdfParams: kdfParams))
            }
        }
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

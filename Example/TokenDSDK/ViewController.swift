import UIKit
import TokenDSDK
import DLCryptoKit
import TokenDWallet

// swiftlint:disable file_length type_body_length force_try line_length
class ViewController: UIViewController, RequestSignKeyDataProviderProtocol {
    
    var privateKey: ECDSA.KeyData?
    
    func getPrivateKeyData() -> ECDSA.KeyData? {
        return privateKey
    }
    
    func getPublicKeyString() -> String? {
        guard let publicKey = self.privateKey?.getPublicKeyData() else { return nil }
        return Base32Check.encode(version: .accountIdEd25519, data: publicKey)
    }
    
    lazy var apiConfig: ApiConfiguration = {
        return ApiConfiguration(
            urlString: Constants.apiUrlString,
            userAgent: self.getUserAgent()
        )
    }()
    
    var walletData: WalletDataModel?
    
    lazy var apiCallbacks: ApiCallbacks = {
        return ApiCallbacks(onTFARequired: { [weak self] input, cancel  in
            self?.initiateTFA(input: input, cancel: cancel)
        })
    }()
    
    lazy var verifyApi: TokenDSDK.TFAVerifyApi = {
        let api = TokenDSDK.TFAVerifyApi(
            apiConfiguration: self.apiConfig,
            requestSigner: RequestSigner(keyDataProvider: self)
        )
        return api
    }()
    
    lazy var tokenDApi: TokenDSDK.API = {
        let api = TokenDSDK.API(
            configuration: self.apiConfig,
            callbacks: self.apiCallbacks,
            keyDataProvider: self
        )
        return api
    }()
    
    lazy var keyServerApi: TokenDSDK.KeyServerApi = {
        let api = TokenDSDK.KeyServerApi(
            apiConfiguration: self.apiConfig,
            callbacks: self.apiCallbacks,
            verifyApi: self.verifyApi,
            requestSigner: RequestSigner(keyDataProvider: self)
        )
        return api
    }()
    
    lazy var usersApi: TokenDSDK.UsersApi = {
        let api = TokenDSDK.UsersApi(
            apiConfiguration: self.apiConfig,
            requestSigner: RequestSigner(keyDataProvider: self)
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
    
    var accountId: String {
        return self.walletData!.accountId
    }
    
    var inputTFAText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
                                
                                self.recoverAccountWith(
                                    email: email,
                                    recoverySeed: seed,
                                    newPassword: newPassword
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
                                
                                self.changePassword(
                                    email: email,
                                    oldPassword: oldPassword,
                                    newPassword: newPassword
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
        self.keyServerApi.createWallet(
            email: email,
            password: password,
            referrerAccountId: nil,
            completion: { [weak self] (result) in
                
                switch result {
                    
                case .failure(let error):
                    self?.showError(title: "Register", error)
                    
                case .success(let info, let walletData, let keyPair, let recoveryKey):
                    print("info: \(info.debugDescription)")
                    print("walletData: \(walletData)")
                    print("key seed: \(Base32Check.encode(version: .seedEd25519, data: keyPair.getPrivateKeyData()))")
                    Constants.userEmail = email
                    Constants.userPassword = password
                    let seedBase32Check = Base32Check.encode(version: .seedEd25519, data: recoveryKey.getSeedData())
                    print("recovery seed: \(seedBase32Check)")
                    Constants.recoverySeed = seedBase32Check
                    self?.showRecoverySeedAlert(seedBase32Check: seedBase32Check, completion: {
                        self?.performLogin { _ in
                            
                        }
                    })
                }
        })
    }
    
    func recoverAccountWith(email: String, recoverySeed: String, newPassword: String) {
        self.tokenDApi.generalApi.requestNetworkInfo(completion: { [weak self] (result) in
            switch result {
                
            case .failed(let error):
                self?.showError(error)
                
            case .succeeded(let networkInfo):
                _ = self?.keyServerApi.recoverWallet(
                    email: email,
                    recoverySeedBase32Check: recoverySeed,
                    newPassword: newPassword,
                    networkInfo: networkInfo,
                    completion: { (result) in
                        switch result {
                            
                        case .failed(let error):
                            self?.showError(error)
                            
                        case .succeeded(_, _, let newKey):
                            let seed = Base32Check.encode(version: .seedEd25519, data: newKey.getSeedData())
                            print("Changed key seed: \(seed)")
                            Constants.userPassword = newPassword
                            self?.performLogin { _ in
                                
                            }
                        }
                })
            }
        })
    }
    
    func changePassword(email: String, oldPassword: String, newPassword: String) {
        self.tokenDApi.generalApi.requestNetworkInfo(completion: { [weak self] (result) in
            switch result {
                
            case .failed(let error):
                self?.showError(error)
                
            case .succeeded(let networkInfo):
                _ = self?.keyServerApi.changeWalletPassword(
                    email: email,
                    oldPassword: oldPassword,
                    newPassword: newPassword,
                    networkInfo: networkInfo,
                    completion: { (result) in
                        switch result {
                            
                        case .failed(let error):
                            self?.showError(error)
                            
                        case .succeeded(_, _, let newKey):
                            let seed = Base32Check.encode(version: .seedEd25519, data: newKey.getSeedData())
                            print("Changed key seed: \(seed)")
                            Constants.userPassword = newPassword
                            self?.performLogin { _ in
                                
                            }
                        }
                })
            }
        })
    }
    
    func performLogin(onSuccess: @escaping (_ walletData: WalletDataModel) -> Void) {
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
                    
                    self?.checkAndCreateUser(
                        accountId: walletData.accountId,
                        completion: { [weak self] checkResult in
                            switch checkResult {
                                
                            case .failure(let error):
                                self?.showError(error)
                                
                            case .success:
                                onSuccess(walletData)
                            }
                    })
                    
                case .failure(let error):
                    self?.showError(title: "Login", error)
                }
        })
    }
    
    enum CheckAndCreateUserResult {
        case failure(Swift.Error)
        case success
    }
    func checkAndCreateUser(accountId: String, completion: @escaping (_ result: CheckAndCreateUserResult) -> Void) {
        self.usersApi.getUser(accountId: accountId, completion: { [weak self] result in
            switch result {
                
            case .failure(let errors):
                if errors.contains(status: ApiError.Status.notFound) {
                    self?.usersApi.createUser(accountId: accountId, completion: { createResult in
                        switch createResult {
                            
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success:
                            completion(.success)
                        }
                    })
                } else {
                    completion(.failure(errors))
                }
                
            case .success:
                completion(.success)
            }
        })
    }
    
    func requestOrderBook() {
        self.tokenDApi.orderBookApi.requestOrderBook(
            parameters: OrderBookRequestParameters(
                isBuy: true,
                baseAsset: "BTC",
                quoteAsset: "ETH"
            ),
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
        self.tokenDApi.accountApi.requestAccount(
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
        self.tokenDApi.generalApi.requestAccountId(
        email: email) { [weak self] (result) in
            switch result {
            case .succeeded:
                print("\(#function) - success")
            case .failed(let error):
                self?.showError(error)
            }
        }
    }
    
    func requestSigners() {
        self.tokenDApi.accountApi.requestSigners(
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
            case .succeeded:
                print("\(#function) - success")
            case .failed(let error):
                self?.showError(error)
            }
        }
    }
    
    private func requestCharts() {
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
    
    private func sendTransaction(
        networkInfo: NetworkInfoModel,
        walletData: WalletDataModel,
        key: ECDSA.KeyData,
        sourceBalanceId: String,
        asset: String
        ) {
        
        self.tokenDApi.generalApi.requestAccountId(
            email: Constants.sendTransactionDestinationEmail,
            completion: { result in
                switch result {
                    
                case .failed(let error):
                    print("\(#function) - failure: \(error)")
                    
                case .succeeded(let response):
                    self.sendTransaction(
                        networkInfo: networkInfo,
                        walletData: walletData,
                        key: key,
                        sourceBalanceId: sourceBalanceId,
                        asset: asset,
                        destinationAccountId: response.accountId
                    )
                }
        })
    }
    
    private func sendTransaction(
        networkInfo: NetworkInfoModel,
        walletData: WalletDataModel,
        key: ECDSA.KeyData,
        sourceBalanceId: String,
        asset: String,
        destinationAccountId: String
        ) {
        
        let sourceFee = FeeDataV2(
            maxPaymentFee: 0,
            fixedFee: 0,
            feeAsset: asset,
            ext: FeeDataV2.FeeDataV2Ext.emptyVersion()
        )
        let destinationFee = FeeDataV2(
            maxPaymentFee: 0,
            fixedFee: 0,
            feeAsset: asset,
            ext: FeeDataV2.FeeDataV2Ext.emptyVersion()
        )
        
        let feeData = PaymentFeeDataV2(
            sourceFee: sourceFee,
            destinationFee: destinationFee,
            sourcePaysForDest: true,
            ext: PaymentFeeDataV2.PaymentFeeDataV2Ext.emptyVersion()
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
        
        let operation = PaymentOpV2(
            sourceBalanceID: sourceBalanceID,
            destination: .account(destinationAccountID),
            amount: amount,
            feeData: feeData,
            subject: "",
            reference: "",
            ext: PaymentOpV2.PaymentOpV2Ext.emptyVersion()
        )
        
        let sendDate = Date()
        let transactionBuilder: TransactionBuilder = TransactionBuilder(
            networkParams: networkInfo.networkParams,
            sourceAccountId: sourceAccountID,
            params: networkInfo.getTxBuilderParams(sendDate: sendDate)
        )
        
        transactionBuilder.add(
            operationBody: .paymentV2(operation),
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
    
    private func getFactors(walletId: String) {
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
    
    private func updateTOTPFactor(walletId: String, factorId: Int, priority: Int) {
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
    private func deleteTOTPFactors(
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
                            
                            self?.requestFee(asset: quotedAsset.asset, feeType: .offerFee, amount: feeAmount)
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
                        blobId: saleDetails.details.description,
                        fundId: nil
                    )
                }
        })
    }
    
    func requestFee(asset: String, feeType: FeeResponse.FeeType, amount: Decimal?) {
        self.tokenDApi.generalApi.requestFee(
            accountId: self.accountId,
            asset: asset,
            feeType: feeType,
            amount: amount,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failed(let errors):
                    self?.showError(errors)
                    
                case .succeeded(let fee):
                    print("\(#function) - fee success: \(fee)")
                }
        })
    }
    
    func requestBlob(
        accountId: String,
        blobId: String,
        fundId: String?
        ) {
        
        self.usersApi.getBlob(
            BlobResponse.self,
            accountId: self.accountId,
            blobId: blobId,
            fundId: fundId,
            tokenCode: nil,
            fundOwner: nil,
            type: nil,
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
    
    private func initiateTFA(input: ApiCallbacks.TFAInput, cancel: @escaping () -> Void) {
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
    
    private func getUserAgent() -> String {
        let appPrefix = "TOKEND_SDK"
        let userAgent = "\(appPrefix)|\(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "")|\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")|\(UIDevice.current.name)|\(self.platform()) \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        
        return userAgent
    }
    
    private func platform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(
            bytes: Data(
                bytes: &sysinfo.machine,
                count: Int(_SYS_NAMELEN)
            ),
            encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    @objc func tfaTextFieldEditingChanged(_ tf: UITextField) {
        self.inputTFAText = tf.text ?? ""
    }
}

extension TokenDWallet.PublicKey {
    init?(
        base32EncodedString: String,
        expectedVersion: Base32Check.VersionByte
        ) {
        
        guard let data = try? Base32Check.decodeCheck(
            expectedVersion: expectedVersion,
            encoded: base32EncodedString
            ) else {
                return nil
        }
        
        var uint = Uint256()
        uint.wrapped = data
        self = .keyTypeEd25519(uint)
    }
}
// swiftlint:enable file_length type_body_length force_try line_length

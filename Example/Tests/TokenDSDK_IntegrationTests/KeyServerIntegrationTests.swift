import XCTest
@testable import TokenDSDK
import TokenDWallet
import DLCryptoKit

class KeyServerIntegrationTests: BaseIntegrationTests {
    
    // MARK: - Public properties
    
    public var balances: [BalanceDetails]?
    public var balancesError: Swift.Error?
    
    public let historyRequestLimit: Int = 10
    
    // MARK: - Private properties
    
    private var testEmail: String = ""
    private var testPassword: String = ""
    
    private var kdfParams: KDFParams?
    
    private var requestTimeout: TimeInterval {
        return 60.0
    }
    
    private var registeredMasterKeyPair: ECDSA.KeyData?
    private var registeredRecoverySeed: String?
    private var registeredWalletData: WalletDataModel?
    
    private lazy var signUpRequestBuilder: SignUpRequestBuilder = {
        return SignUpRequestBuilder(keyServerApi: self.keyServerApi)
    }()
    private lazy var updatePasswordRequestBuilder: UpdatePasswordRequestBuilder = {
        return UpdatePasswordRequestBuilder(keyServerApi: self.keyServerApi)
    }()
    
    override var apiCallbacks: ApiCallbacks {
        return ApiCallbacks(
            onTFARequired: { (tfaInput, cancel) in
                self.onDefaultTFA(tfaInput: tfaInput, cancel: cancel)
        },
            onUnathorizedRequest: { (error) in
                print("onUnathorizedRequest: \(error)")
        })
    }
    
    // MARK: - Overridden
    
    override func setUp() {
        super.setUp()
        
        self.testEmail = self.generateRandomEmail()
        self.testPassword = self.generateRandomPassword()
    }
    
    override func shouldSignIn() -> Bool {
        return false
    }
    
    override func getPrivateKeyData(completion: @escaping (ECDSA.KeyData?) -> Void) {
        completion(self.registeredMasterKeyPair)
    }
    
    override func getPublicKeyString(completion: @escaping (String?) -> Void) {
        guard let publicKeyData = self.registeredMasterKeyPair?.getPublicKeyData() else {
            completion(nil)
            return
        }
        
        let publicKey = Base32Check.encode(version: .accountIdEd25519, data: publicKeyData)
        completion(publicKey)
    }
    
    // MARK: - Public
    
    func testGetDefaultKDF() {
        guard self.isServerReachable else {
            XCTAssert(false, "Server is not reachable")
            return
        }
        
        let expectation = XCTestExpectation(description: "\(self) - \(#function)")
        self.keyServerApi.requestDefaultKDF(completion: { (result) in
            switch result {
                
            case .failure(let error):
                XCTAssert(false, "Failed to fetch default KDF: \(error)")
                
            case .success:
                XCTAssert(true)
            }
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: BaseIntegrationTests.requestTimeoutDuraton)
    }
    
    func testSignUpSignChangePassword() {
        guard self.isServerReachable else {
            XCTAssert(false, "Server is not reachable")
            return
        }
        
        let expectation = XCTestExpectation(description: "SignUp process")
        
        let onFailed: (_ reason: String) -> Void = { (reason) in
            XCTAssert(false, reason)
            expectation.fulfill()
        }
        
        let performSignUp: (_ onSuccess: @escaping () -> Void) -> Void = { (onSuccess) in
            self.performSignUp(onSuccess: onSuccess, onFailed: onFailed)
        }
        
        let performSignIn: (_ onSuccess: @escaping () -> Void) -> Void = { (onSuccess) in
            self.performSignIn(onSuccess: onSuccess, onFailed: onFailed)
        }
        
        let performPasswordUpdate: (_ onSuccess: @escaping () -> Void) -> Void = { (onSuccess) in
            self.performPasswordUpdate(onSuccess: onSuccess, onFailed: onFailed)
        }
        
        let consecutiveOperations: [(_ onSuccess: @escaping () -> Void) -> Void] = [
            performSignUp,
            performSignIn,
            performPasswordUpdate
        ]
        
        var performNextOperationRef: ((_ operationIndex: Int) -> Void)?
        
        let performNextOperation: (_ operationIndex: Int) -> Void = { (operationIndex) in
            guard operationIndex < consecutiveOperations.count else {
                XCTAssert(true)
                expectation.fulfill()
                return
            }
            
            let nextOperation = consecutiveOperations[operationIndex]
            nextOperation({
                performNextOperationRef?(operationIndex + 1)
            })
        }
        
        performNextOperationRef = performNextOperation
        
        performNextOperation(0)
        
        self.wait(for: [expectation], timeout: self.requestTimeout * Double(consecutiveOperations.count))
    }
    
    // MARK: - Private
    
    private func performSignUp(
        onSuccess: @escaping () -> Void,
        onFailed: @escaping (_ reason: String) -> Void
        ) {
        
        let email = self.testEmail
        let password = self.testPassword
        
        self.signUpRequestBuilder.buildSignUpRequest(
            email: email,
            password: password,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    onFailed("Failed to build sign up request: \(error.localizedDescription)")
                    
                case .success(let email, let recoveryKey, let walletInfo, let walletKDF):
                    self.signUp(
                        email: email,
                        recoveryKey: recoveryKey,
                        walletInfo: walletInfo,
                        walletKDF: walletKDF,
                        completion: { (signUpResult) in
                            switch signUpResult {
                                
                            case .failed(let error):
                                onFailed("Failed to sign up: \(error.localizedDescription)")
                                
                            case .succeeded(_, let walletData, let recoverySeed):
                                self.registeredWalletData = walletData
                                self.registeredRecoverySeed = recoverySeed
                                onSuccess()
                            }
                    })
                }
        })
    }
    
    private func performSignIn(
        onSuccess: @escaping () -> Void,
        onFailed: @escaping (_ reason: String) -> Void
        ) {
        
        self.keyServerApi.loginWith(
            email: self.testEmail,
            password: self.testPassword,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    onFailed("Failed to sign in: \(error)")
                    
                case .success(let walletData, let keyPair):
                    guard self.registeredWalletData?.accountId == walletData.accountId else {
                        onFailed("SignUp and SignIn account ids not match")
                        return
                    }
                    
                    self.registeredMasterKeyPair = keyPair
                    onSuccess()
                }
        })
    }
    
    private func performPasswordUpdate(
        onSuccess: @escaping () -> Void,
        onFailed: @escaping (_ reason: String) -> Void
        ) {
        
        let oldPassword = self.testPassword
        let newPassword = self.generateRandomPassword()
        
        let email = self.testEmail
        let onSignRequest = JSONAPI.RequestSignerBlockCaller.getUnsafeSignRequestBlock()
        
        _ = self.updatePasswordRequestBuilder.buildChangePasswordRequest(
            email: email,
            oldPassword: oldPassword,
            newPassword: newPassword,
            onSignRequest: onSignRequest,
            networkInfo: networkInfo,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    onFailed("Failed to build update password request: \(error.localizedDescription)")
                    
                case .success(let components):
                    self?.changePassword(
                        email: components.email,
                        walletId: components.walletId,
                        signingPassword: components.signingPassword,
                        walletKDF: components.walletKDF,
                        walletInfo: components.walletInfo,
                        requestSigner: components.requestSigner,
                        completion: { (changePasswordResult) in
                            switch changePasswordResult {
                                
                            case .failed(let error):
                                onFailed("Failed to change password: \(error.localizedDescription)")
                                
                            case .succeeded:
                                onSuccess()
                            }
                    })
                }
        })
    }
    
    private func performPasswordRecovery(
        onSuccess: @escaping () -> Void,
        onFailed: @escaping (_ reason: String) -> Void
        ) {
        
        let email = self.testEmail
        let seed = self.registeredRecoverySeed!
        let newPassword = self.generateRandomPassword()
        
        let onSignRequest = JSONAPI.RequestSignerBlockCaller.getUnsafeSignRequestBlock()
        
        _ = self.updatePasswordRequestBuilder.buildRecoveryWalletRequest(
            email: email,
            recoverySeedBase32Check: seed,
            newPassword: newPassword,
            onSignRequest: onSignRequest,
            networkInfo: networkInfo,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    onFailed("Failed to build recover password request: \(error.localizedDescription)")
                    
                case .success(let components):
                    self?.recoverWallet(
                        email: components.email,
                        walletId: components.walletId,
                        signingPassword: components.signingPassword,
                        walletKDF: components.walletKDF,
                        walletInfo: components.walletInfo,
                        requestSigner: components.requestSigner,
                        completion: { (recoverPasswordResult) in
                            switch recoverPasswordResult {
                                
                            case .failed(let error):
                                onFailed("Failed to recover password: \(error.localizedDescription)")
                                
                            case .succeeded:
                                onSuccess()
                            }
                    })
                }
        })
    }
    
    // MARK: -
    
    enum SignError: Swift.Error, LocalizedError {
        case emailAlreadyTaken
        case emailShouldBeVerified(walletId: String)
        case otherError(Swift.Error)
        case tfaFailed
        case wrongEmail
        case wrongPassword
    }
    
    enum SignUpResult {
        case failed(SignError)
        case succeeded(account: String, walletData: WalletDataModel, recoverySeed: String)
    }
    
    private func signUp(
        email: String,
        recoveryKey: ECDSA.KeyData,
        walletInfo: WalletInfoModel,
        walletKDF: WalletKDFParams,
        completion: @escaping (SignUpResult) -> Void
        ) {
        
        self.keyServerApi.createWallet(
            walletInfo: walletInfo,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    let signError: SignError
                    
                    switch error {
                        
                    case .emailAlreadyTaken:
                        signError = .emailAlreadyTaken
                        
                    default:
                        signError = .otherError(error)
                    }
                    
                    completion(.failed(signError))
                    
                case .success(let response):
                    let walletDataModel = WalletDataModel(
                        email: email,
                        accountId: walletInfo.data.attributes.accountId,
                        walletId: response.id,
                        type: response.type,
                        keychainData: walletInfo.data.attributes.keychainData,
                        walletKDF: walletKDF,
                        verified: response.attributes.verified
                    )
                    
                    let recoverySeed = Base32Check.encode(version: .seedEd25519, data: recoveryKey.getSeedData())
                    
                    completion(.succeeded(
                        account: walletDataModel.email,
                        walletData: walletDataModel,
                        recoverySeed: recoverySeed
                        )
                    )
                }
        })
    }
    
    enum UpdatePasswordSubmitResult {
        case failed(Swift.Error)
        case succeeded
    }
    
    private func changePassword(
        email: String,
        walletId: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        walletInfo: WalletInfoModel,
        requestSigner: JSONAPI.RequestSignerProtocol,
        completion: @escaping (UpdatePasswordSubmitResult) -> Void
        ) {
        
        _ = self.keyServerApi.performUpdatePasswordRequest(
            email: email,
            walletId: walletId,
            signingPassword: signingPassword,
            walletKDF: walletKDF,
            walletInfo: walletInfo,
            requestSigner: requestSigner,
            completion: { (result) in
                switch result {
                    
                case .failed(let error):
                    completion(.failed(error))
                    
                case .succeeded:
                    completion(.succeeded)
                }
        })
    }
    
    private func recoverWallet(
        email: String,
        walletId: String,
        signingPassword: String,
        walletKDF: WalletKDFParams,
        walletInfo: WalletInfoModel,
        requestSigner: JSONAPI.RequestSignerProtocol,
        completion: @escaping (_ result: UpdatePasswordSubmitResult) -> Void
        ) {
        
        _ = self.keyServerApi.performUpdatePasswordRequest(
            email: email,
            walletId: walletId,
            signingPassword: signingPassword,
            walletKDF: walletKDF,
            walletInfo: walletInfo,
            requestSigner: requestSigner,
            completion: { (result) in
                switch result {
                    
                case .failed(let error):
                    completion(.failed(error))
                    
                case .succeeded:
                    completion(.succeeded)
                }
        })
    }
    
    // MARK: - TFA
    
    private func onDefaultTFA(tfaInput: ApiCallbacks.TFAInput, cancel: @escaping () -> Void) {
        switch tfaInput {
            
        case .password(let tokenSignData, let inputCallback):
            guard let kdfParams = self.kdfParams else {
                cancel()
                return
            }
            
            let email = self.testEmail
            let password = self.testPassword
            
            self.processInput(
                email: email,
                password: password,
                kdfParams: kdfParams,
                tokenSignData: tokenSignData,
                inputCallback: inputCallback,
                cancel: cancel
            )
            
        case .code:
            cancel()
        }
    }
    
    private func processInput(
        email: String,
        password: String,
        kdfParams: KDFParams,
        tokenSignData: ApiCallbacks.TokenSignData,
        inputCallback: @escaping (_ signedToken: String) -> Void,
        cancel: @escaping () -> Void
        ) {
        
        guard
            let signedToken = self.getSignedTokenForPassword(
                password,
                walletId: tokenSignData.walletId,
                keychainData: tokenSignData.keychainData,
                email: email,
                token: tokenSignData.token,
                factorId: tokenSignData.factorId,
                walletKDF: WalletKDFParams(
                    kdfParams: kdfParams,
                    salt: tokenSignData.salt
                )
            ) else {
                cancel()
                return
        }
        inputCallback(signedToken)
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
                return nil
        }
        
        guard let data = token.data(using: .utf8) else {
            return nil
        }
        
        guard let signedToken = try? ECDSA.signED25519(data: data, keyData: keyPair).base64EncodedString() else {
            return nil
        }
        
        return signedToken
    }
}

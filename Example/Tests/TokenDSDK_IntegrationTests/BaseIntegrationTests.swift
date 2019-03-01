import XCTest
import TokenDSDK
import DLJSONAPI
import TokenDWallet
import DLCryptoKit

class BaseIntegrationTests: XCTestCase, RequestSignKeyDataProviderProtocol {
    
    // MARK: - Public properties
    
    public static let requestTimeoutDuraton: TimeInterval = 30.0
    
    public lazy var apiConfiguration: ApiConfiguration = {
        return ApiConfiguration(
            urlString: IntegrationTestsConstants.apiUrlString
        )
    }()
    
    public lazy var apiCallbacksJSONAPI: JSONAPI.ApiCallbacks = {
        return JSONAPI.ApiCallbacks(
            onUnathorizedRequest: { (error) in
                print("onUnathorizedRequest: \(error)")
        })
    }()
    
    public lazy var resourcePool: ResourcePool = ResourcePool(
        queue: DispatchQueue(label: "test.queue", attributes: .concurrent)
    )
    
    public lazy var networkJSONAPI: JSONAPI.NetworkProtocol = {
        return JSONAPI.AlamofireNetwork(
            resourcePool: self.resourcePool,
            onUnathorizedRequest: self.apiCallbacksJSONAPI.onUnathorizedRequest
        )
    }()
    
    public lazy var requestSignerJSONAPI: JSONAPI.RequestSignerProtocol = {
        return JSONAPI.RequestSigner(keyDataProvider: self)
    }()
    
    public var apiCallbacks: ApiCallbacks {
        return ApiCallbacks(
            onTFARequired: { (_, _) in
                
        },
            onUnathorizedRequest: { (error) in
                print("onUnathorizedRequest: \(error)")
        })
    }
    
    public lazy var network: NetworkProtocol = {
        return AlamofireNetwork(
            onUnathorizedRequest: self.apiCallbacks.onUnathorizedRequest
        )
    }()
    
    public lazy var requestSigner: RequestSignerProtocol = {
        return RequestSigner(keyDataProvider: self)
    }()
    
    public var apiV3: APIv3!
    
    public var api: API!
    public var tfaVerifyApi: TFAVerifyApi!
    public var keyServerApi: KeyServerApi!
    
    public var isServerReachable: Bool = false
    public var networkInfo: NetworkInfoModel!
    public var networkInfoError: Swift.Error?
    
    public var privateKey: ECDSA.KeyData?
    public var walletData: WalletDataModel!
    public var signInError: Swift.Error?
    public var isSignedIn: Bool {
        return self.privateKey != nil && self.walletData != nil
    }
    
    // MARK: - Overridden
    
    override func setUp() {
        super.setUp()
        
        self.apiV3 = APIv3(
            configuration: self.apiConfiguration,
            callbacks: self.apiCallbacksJSONAPI,
            network: self.networkJSONAPI,
            requestSigner: self.requestSignerJSONAPI
        )
        
        self.api = API(
            configuration: self.apiConfiguration,
            callbacks: self.apiCallbacks,
            network: self.network,
            requestSigner: self.requestSigner
        )
        
        self.tfaVerifyApi = TFAVerifyApi(
            apiConfiguration: self.apiConfiguration,
            requestSigner: self.requestSigner,
            network: self.network
        )
        
        self.keyServerApi = KeyServerApi(
            apiConfiguration: self.apiConfiguration,
            callbacks: self.apiCallbacks,
            verifyApi: self.tfaVerifyApi,
            requestSigner: self.requestSignerJSONAPI,
            network: self.network,
            networkV3: self.networkJSONAPI
        )
        
        var networkInfoRequested = false
        self.checkServerReachable(completion: {
            networkInfoRequested = true
        })
        while !networkInfoRequested {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
        
        guard self.isServerReachable else {
            print("Server info is not reachable")
            return
        }
        
        if self.shouldSignIn() {
            var signedInd = false
            self.signIn(completion: {
                signedInd = true
            })
            while !signedInd {
                RunLoop.current.run(mode: .default, before: Date.distantFuture)
            }
        }
    }
    
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
    
    // MARK: - Tests
    
    func shouldSignIn() -> Bool {
        return false
    }
    
    func testServerReachable() {
        guard self.isServerReachable else {
            XCTAssert(false, "Failed to get network info: \(String(describing: self.networkInfoError))")
            return
        }
        
        XCTAssert(true)
    }
    
    func testSignedIn() {
        guard self.shouldSignIn() else {
            XCTAssert(true)
            return
        }
        
        guard self.isSignedIn else {
            XCTAssert(false, "Failed to sign in: \(String(describing: self.signInError))")
            return
        }
        
        XCTAssert(true)
    }
    
    // MARK: - Public
    
    public func generateRandomEmail() -> String {
        let timestamp = Int(Date().timeIntervalSinceReferenceDate)
        let email = "iOStest\(timestamp)@tokendintegration.com"
        
        return email
    }
    
    public func generateRandomPassword() -> String {
        let timestamp = Int(Date().timeIntervalSinceReferenceDate)
        let timestampData = Data(String(timestamp).utf8)
        let password = Common.SHA.sha256(data: timestampData).base64EncodedString()
        
        return password
    }
    
    // MARK: - Private
    
    private func checkServerReachable(completion: @escaping () -> Void) {
        self.api.generalApi.requestNetworkInfo(completion: { [weak self] (result) in
            switch result {
                
            case .failed(let error):
                self?.isServerReachable = false
                self?.networkInfoError = error
                
            case .succeeded(let networkInfo):
                self?.isServerReachable = true
                self?.networkInfo = networkInfo
            }
            
            completion()
        })
    }
    
    private func signIn(completion: @escaping () -> Void) {
        self.keyServerApi.loginWith(
            email: IntegrationTestsConstants.email,
            password: IntegrationTestsConstants.password,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    self?.signInError = error
                    
                case .success(let walletData, let keyPair):
                    self?.walletData = walletData
                    self?.privateKey = keyPair
                }
                
                completion()
        })
    }
}

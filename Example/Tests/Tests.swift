import XCTest
import TokenDSDK
import DLCryptoKit
import TokenDWallet

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // swiftlint:disable line_length force_try
    
    func testSignHeaders() {
        
        let expectedSignature: String = "rxJB/AAAAECE+bUi4D3fDiLjQWzYKqEG7iAS/VDsVhWTh+Gaa4SdHkDK4x1zuaRuSBBvmGzbQ569NcPd1NNYDjtcGHgpPMoL"
        
        let seedHex: String = "d01d479c96bcc1b8f9bb2b5e5909a8be2fd8db9a5be4a5e151e2ac0dcbde84a4"
        let privateKey: ECDSA.KeyData = try! ECDSA.KeyData(seed: seedHex.hexadecimal()!)
        let keyDataProvider = UnsafeRequestSignKeyDataProvider(keyPair: privateKey)
        let signer = RequestSigner(keyDataProvider: keyDataProvider)
        let requestModel = RequestSignParametersModel(urlString: "https://google.com/assets")
        let data = signer.sign(request: requestModel, sendDate: Date(timeIntervalSince1970: 1533130009 - signer.validUntilDuration))
        let signatureBase64 = data["X-AuthSignature"]!
        
        XCTAssert(signatureBase64 == expectedSignature, "Headers signature doesn't match")
    }
    
    func testCreateRegistrationInfo() {
        guard
            let keyPair = try? ECDSA.KeyData(),
            let recoveryKeyPair = try? ECDSA.KeyData(),
            let passwordFactorKey = try? ECDSA.KeyData()
            else {
                XCTAssert(false, "CreateRegistrationInfo failed to generate key")
                return
        }
        
        let email = "email@example.com"
        let password = "password"
        let kdfParams = KDFParams(
            algorithm: "scrypt",
            bits: 256,
            id: "2",
            n: 4096,
            p: 1,
            r: 8,
            type: "2"
        )
        
        let keychainParams = WalletInfoBuilder.KeychainParams(
            newKeyPair: keyPair,
            recoveryKeyPair: recoveryKeyPair,
            passwordFactorKey: passwordFactorKey
        )
        
        let createdInfoResult = WalletInfoBuilder.createWalletInfo(
            email: email,
            password: password,
            kdfParams: kdfParams,
            keychainParams: keychainParams,
            transaction: nil,
            referrerAccountId: nil
        )
        
        switch createdInfoResult {
            
        case .failed(let error):
            XCTAssert(false, "CreateRegistrationInfo failed: \(error)")
            
        case .succeeded:
            XCTAssert(true)
        }
    }
    
    // swiftlint:enable line_length force_try
}

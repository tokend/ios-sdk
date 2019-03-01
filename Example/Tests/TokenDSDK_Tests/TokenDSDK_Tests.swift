import XCTest
import TokenDSDK
import DLCryptoKit
import TokenDWallet

class TokenDSDKTests: XCTestCase {
    
    // swiftlint:disable line_length force_try
    
    func testSignHeaders() {
        
        let expected: String = "keyId=\"GBLTOG6EJS5OWDNQNSCEAVDNMPBY6F73XZHHKR27YE5AKE23ZZEXOLBK\",algorithm=\"ed25519-sha256\",signature=\"w/y3EsliTmQPC6MS88N/kjU/hFVxlIdhFhzfRGv4yIsSokgMpxVqxcC/CmUsAN4t3BKpskGG7+JEWryV8NXvCg==\",headers=\"date (request-target)\""
        
        let seed = "SCDMOOXVNMO6SA22AYUMZDIGLDJMBUTVEGB73FFNTLFJILBJWIU4NQ3D"
        let seedData = try! Base32Check.decodeCheck(expectedVersion: .seedEd25519, encoded: seed)
        let privateKey: ECDSA.KeyData = try! ECDSA.KeyData(seed: seedData)
        let keyDataProvider = UnsafeRequestSignKeyDataProvider(keyPair: privateKey)
        let signer = RequestSigner(keyDataProvider: keyDataProvider)
        let requestModel = RequestSignParametersModel(
            baseUrlString: "api.tokend.io",
            urlString: "api.tokend.io/users",
            httpMethod: .get,
            parameters: ["type": 2],
            parametersEncoding: RequestParametersEncoding.url
        )
        
        signer.dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let sendDate = signer.dateFormatter.date(from: "Fri, 05 Jan 2018 21:31:40 GMT") else {
            XCTAssert(false, "RequestSigner date formatter failed")
            return
        }
        
        let expectation = XCTestExpectation(description: "Sign request headers")
        
        signer.sign(
            request: requestModel,
            sendDate: sendDate,
            completion: { (signedHeaders) in
                let authorization: String = signedHeaders?["Authorization"] ?? ""
                
                XCTAssert(authorization == expected, "Headers signature doesn't match: \(authorization)\n expected: \(expected)")
                expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testCreateRegistrationInfo() {
        guard
            let keyPair = try? ECDSA.KeyData(),
            let recoveryKeyPair = try? ECDSA.KeyData(),
            let passwordFactorKeyPair = try? ECDSA.KeyData()
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
            passwordFactorKeyPair: passwordFactorKeyPair
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

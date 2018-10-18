import Foundation
import DLCryptoKit
import TokenDWallet

public struct RequestSignParametersModel {
    public let urlString: String
    public let parameters: RequestParameters?
    public let parametersEncoding: RequestParametersEncoding?
    
    public init(
        urlString: String,
        parameters: RequestParameters? = nil,
        parametersEncoding: RequestParametersEncoding? = nil
        ) {
        self.urlString = urlString
        self.parameters = parameters
        self.parametersEncoding = parametersEncoding
    }
}

public protocol RequestSignerProtocol {
    func sign(
        request: RequestSignParametersModel,
        sendDate: Date
        ) -> RequestHeaders
}

public class RequestSigner: RequestSignerProtocol {
    public let validUntilDuration: TimeInterval = 3600
    
    private let keyDataProvider: RequestSignKeyDataProviderProtocol
    
    public init(keyDataProvider: RequestSignKeyDataProviderProtocol) {
        self.keyDataProvider = keyDataProvider
    }
    
    // MARK: - RequestSignerProtocol
    
    /// Method signs the given request
    /// - Parameters:
    ///    - request: The request to be signed
    ///    - sendDate: Send date of the request
    /// - Returns: `RequestHeaders`
    public func sign(
        request: RequestSignParametersModel,
        sendDate: Date
        ) -> RequestHeaders {
        
        guard let url = URL(string: request.urlString) else {
            return RequestHeaders()
        }
        
        return self.sign(
            url: self.urlFor(
                url: url,
                parameters: request.parameters,
                parametersEncoding: request.parametersEncoding
            ),
            sendDate: sendDate
        )
    }
    
    // MARK: - Private
    
    private func urlFor(
        url: URL,
        parameters: RequestParameters?,
        parametersEncoding: RequestParametersEncoding?
        ) -> URL {
        if let parameters = parameters, let encoding = parametersEncoding?.encoding {
            let request = URLRequest(url: url)
            if let encodedUrl: URL = (try? encoding.encode(request, with: parameters))?.url {
                return encodedUrl
            }
        }
        
        return url
    }
    
    private func sign(
        url: URL,
        sendDate: Date
        ) -> RequestHeaders {
        
        let path = url.path
        let query = url.query ?? ""
        let uri = path + (query.isEmpty ? "" : "?\(query)")
        let validUntil: String = String(Int(floor(sendDate.timeIntervalSince1970 + self.validUntilDuration)))
        
        let signatureBase: String = "{ uri: \'\(uri)\', valid_untill: \'\(validUntil)\'}"
        guard
            let signatureData = signatureBase.data(using: .utf8)
            else {
                return RequestHeaders()
        }
        
        let hashedData = Common.SHA.sha256(data: signatureData)
        
        guard let signatureBaseData = self.sign(hashedData: hashedData) else {
            return RequestHeaders()
        }
        let signatureBase64 = signatureBaseData.toXdrBase64String()
        
        var headers = RequestHeaders()
        headers["X-AuthValidUnTillTimestamp"] = validUntil
        if let publicKey = self.keyDataProvider.getPublicKeyString() {
            headers["X-AuthPublicKey"] = publicKey
        }
        headers["X-AuthSignature"] = signatureBase64
        
        return headers
    }
    
    private func sign(hashedData: Data) -> DecoratedSignature? {
        guard let privateKey = self.keyDataProvider.getPrivateKeyData() else {
            print("keyDataProvider has no private key - unable to sign data")
            return nil
        }
        
        let signature = try? ECDSA.signED25519Decorated(data: hashedData, keyData: privateKey)
        return signature
    }
}

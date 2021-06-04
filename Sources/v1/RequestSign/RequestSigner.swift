import Foundation
import DLCryptoKit
import TokenDWallet

public struct RequestSignParametersModel {
    
    // MARK: - Public properties
    
    public let baseUrlString: String
    public let urlString: String
    public let httpMethod: RequestMethod
    public let parameters: RequestParameters?
    public let parametersEncoding: RequestParametersEncoding?
    
    // MARK: -
    
    public init(
        baseUrlString: String,
        urlString: String,
        httpMethod: RequestMethod,
        parameters: RequestParameters? = nil,
        parametersEncoding: RequestParametersEncoding? = nil
        ) {
        
        self.baseUrlString = baseUrlString.getTrailingSlashTrimmed()
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.parameters = parameters
        self.parametersEncoding = parametersEncoding
    }
}

public typealias SignRequestBlock = (
    _ signingKey: ECDSA.KeyData,
    _ accountId: String,
    _ request: RequestSignParametersModel,
    _ sendDate: Date,
    _ completion: @escaping (RequestHeaders?) -> Void
    ) -> Void

public protocol RequestSignerProtocol {
    func sign(
        request: RequestSignParametersModel,
        sendDate: Date,
        completion: @escaping (RequestHeaders?) -> Void
    )
}

open class RequestSigner: RequestSignerProtocol {
    
    // MARK: - Private types
    
    struct SignatureSubject {
        let key: String
        let value: String
        let shouldIncludeInHeaders: Bool
    }
    
    // MARK: - Public properties
    
    public let dateFormatter: DateFormatter = DateFormatter()
    
    // MARK: - Private properties
    
    private let keyDataProvider: RequestSignKeyDataProviderProtocol
    private let accountIdProvider: RequestSignAccountIdProviderProtocol
    
    // MARK: -
    
    public init(
        keyDataProvider: RequestSignKeyDataProviderProtocol,
        accountIdProvider: RequestSignAccountIdProviderProtocol
    ) {
        
        self.keyDataProvider = keyDataProvider
        self.accountIdProvider = accountIdProvider
        
        let locale = Locale(identifier: "en_US_POSIX")
        self.dateFormatter.locale = locale
        self.dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        self.dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    }
    
    // MARK: - RequestSignerProtocol
    
    /// Method signs the given request
    /// - Parameters:
    ///   - request: The request to be signed
    ///   - sendDate: Send date of the request
    ///   - completion: Returns `RequestHeaders` or nil.
    public func sign(
        request: RequestSignParametersModel,
        sendDate: Date,
        completion: @escaping (RequestHeaders?) -> Void
        ) {
        
        self.sign(
            url: self.getUrlString(
                baseUrlString: request.baseUrlString,
                urlString: request.urlString,
                parameters: request.parameters,
                parametersEncoding: request.parametersEncoding
            ),
            method: request.httpMethod.rawValue,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    // MARK: - Private
    
    private func sign(
        url: String,
        method: String,
        sendDate: Date,
        completion: @escaping (RequestHeaders?) -> Void
        ) {
        
        var subjects: [SignatureSubject] = []
        
        let formattedDate = self.dateFormatter.string(from: sendDate)
        let dateKey = "Date"
        let dateSubject = SignatureSubject(
            key: dateKey,
            value: formattedDate,
            shouldIncludeInHeaders: true
        )
        subjects.append(dateSubject)
        
        let requestTargetKey = "(request-target)"
        let requestSubject = SignatureSubject(
            key: requestTargetKey,
            value: "\(method.lowercased()) \(url)",
            shouldIncludeInHeaders: false
        )
        subjects.append(requestSubject)
        
        self.sign(subjects: subjects, completion: completion)
    }
    
    private func sign(
        subjects: [SignatureSubject],
        completion: @escaping (RequestHeaders?) -> Void
        ) {
        
        var headers: RequestHeaders = [:]
        
        var signatureParts: [String] = []
        
        for subject in subjects {
            let keyPart = subject.key.lowercased()
            let valuePart = subject.value
            let part = "\(keyPart): \(valuePart)"
            signatureParts.append(part)
        }
        
        let signatureBase: String = signatureParts.joined(separator: "\n")
        
        guard
            let signatureData = signatureBase.data(using: .utf8)
            else {
                completion(headers)
                return
        }
        
        let hashedData = Common.SHA.sha256(data: signatureData)
        
        self.sign(hashedData: hashedData, completion: { [weak self] (signature) in
            guard let signatureBaseData = signature else {
                completion(headers)
                return
            }
            
            let signatureBase64 = signatureBaseData.base64EncodedString()
            
            self?.keyDataProvider.getPublicKeyString(completion: { [weak self] (publicKey) in
                guard let publicKey = publicKey else {
                    completion(headers)
                    return
                }
                
                self?.accountIdProvider.getAccountId(completion: { (accountId) in
                    
                    let keyIdPart = "keyId=\"\(publicKey)\""
                    let algorithmPart = "algorithm=\"ed25519-sha256\""
                    let signaturePart = "signature=\"\(signatureBase64)\""
                    
                    let subjectKeys: [String] = subjects.map({ subject -> String in
                        return subject.key
                    })
                    let headersPartValue: String = subjectKeys.joined(separator: " ").lowercased()
                    let headersPart = "headers=\"\(headersPartValue)\""
                    
                    let authString: String = [
                        keyIdPart,
                        algorithmPart,
                        signaturePart,
                        headersPart
                    ].joined(separator: ",")
                    
                    for subject in subjects where subject.shouldIncludeInHeaders {
                        headers[subject.key] = subject.value
                    }
                    
                    headers["Authorization"] = authString
                    headers["Account-Id"] = accountId
                })
            })
            
            completion(headers)
        })
    }
    
    private func getUrlString(
        baseUrlString: String,
        urlString: String,
        parameters: RequestParameters?,
        parametersEncoding: RequestParametersEncoding?
        ) -> String {
        
        let encodedUrl: String
        
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            
            if let encoding = parametersEncoding {
                urlRequest = (try? encoding.encoding.encode(urlRequest, with: parameters)) ?? urlRequest
            }
            
            encodedUrl = urlRequest.url?.absoluteString ?? urlString
        } else {
            encodedUrl = urlString
        }
        
        let trimmedUrl: String
        if let range = encodedUrl.range(of: baseUrlString) {
            trimmedUrl = encodedUrl.replacingCharacters(in: range, with: "")
        } else {
            trimmedUrl = encodedUrl
        }
        
        return trimmedUrl
    }
    
    private func sign(
        hashedData: Data,
        completion: @escaping (Data?) -> Void
        ) {
        
        self.keyDataProvider.getPrivateKeyData(completion: { (keyData) in
            guard let privateKey = keyData else {
                print("keyDataProvider has no private key - unable to sign data")
                completion(nil)
                return
            }
            
            let signature = try? ECDSA.signED25519(data: hashedData, keyData: privateKey)
            completion(signature)
        })
    }
}

open class RequestSignerBlockCaller: RequestSignerProtocol {
    
    // MARK: - Public properties
    
    public let signingKey: ECDSA.KeyData
    public let originalAccountId: String
    public let onSignRequest: SignRequestBlock
    
    public init(
        signingKey: ECDSA.KeyData,
        originalAccountId: String,
        onSignRequest: @escaping SignRequestBlock
        ) {
        
        self.signingKey = signingKey
        self.originalAccountId = originalAccountId
        self.onSignRequest = onSignRequest
    }
    
    // MARK: - Public
    
    public static func getUnsafeSignRequestBlock() -> SignRequestBlock {
        return { signingKey, originalAccountId, request, sendDate, completion in
            let keyDataProvider = UnsafeRequestSignKeyDataProvider(keyPair: signingKey)
            let accountIdProvider = UnsafeRequestSignAccountIdProvider(accountId: originalAccountId)
            var requestSigner: RequestSigner? = RequestSigner(
                keyDataProvider: keyDataProvider,
                accountIdProvider: accountIdProvider
            )
            
            requestSigner?.sign(
                request: request,
                sendDate: sendDate,
                completion: { (headers) in
                    completion(headers)
                    requestSigner = nil
            })
        }
    }
    
    // MARK: - RequestSignerProtocol
    
    public func sign(
        request: RequestSignParametersModel,
        sendDate: Date,
        completion: @escaping (RequestHeaders?) -> Void
        ) {
        
        self.onSignRequest(self.signingKey, self.originalAccountId, request, sendDate, completion)
    }
}

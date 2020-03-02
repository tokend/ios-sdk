import Foundation
import DLCryptoKit
import TokenDWallet

public struct RequestSignParametersModelJSONAPI {
    
    // MARK: - Public properties
    
    public let baseUrl: String
    public let path: String
    public let method: RequestMethod
    public let queryItems: [URLQueryItem]
    public let bodyParameters: RequestBodyParameters?
    public let headers: RequestHeaders?
    public let sendDate: Date
    public let network: JSONAPI.NetworkProtocol
    
    // MARK: -
    
    public init(
        baseUrl: String,
        path: String,
        method: RequestMethod,
        queryItems: [URLQueryItem],
        bodyParameters: RequestBodyParameters?,
        headers: RequestHeaders?,
        sendDate: Date,
        network: JSONAPI.NetworkProtocol
        ) {
        
        self.baseUrl = baseUrl.getTrailingSlashTrimmed()
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.bodyParameters = bodyParameters
        self.headers = headers
        self.sendDate = sendDate
        self.network = network
    }
}

public typealias SignRequestBlockJSONAPI = (
    _ signingKey: ECDSA.KeyData,
    _ request: JSONAPI.RequestSignParametersModel,
    _ completion: @escaping (RequestHeaders?) -> Void
    ) -> Void

public protocol RequestSignerProtocolJSONAPI {
    func sign(
        request: JSONAPI.RequestSignParametersModel,
        completion: @escaping (RequestHeaders?) -> Void
    )
}

extension JSONAPI {
    
    public typealias RequestSignerProtocol = RequestSignerProtocolJSONAPI
    public typealias RequestSignParametersModel = RequestSignParametersModelJSONAPI
    public typealias SignRequestBlock = SignRequestBlockJSONAPI
}

open class RequestSignerJSONAPI: JSONAPI.RequestSignerProtocol {
    
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
    
    // MARK: -
    
    public init(keyDataProvider: RequestSignKeyDataProviderProtocol) {
        self.keyDataProvider = keyDataProvider
        
        let locale = Locale(identifier: "en_US_POSIX")
        self.dateFormatter.locale = locale
        self.dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        self.dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    }
    
    // MARK: - RequestSignerProtocol
    
    /// Method signs the given request
    /// - Parameters:
    ///   - request: The request to be signed
    ///   - completion: Returns `RequestHeaders` or nil.
    public func sign(
        request: JSONAPI.RequestSignParametersModel,
        completion: @escaping (RequestHeaders?) -> Void
        ) {
        
        self.sign(
            path: self.getSignablePathString(
                requestModel: request
            ),
            method: request.method.rawValue,
            sendDate: request.sendDate,
            completion: completion
        )
    }
    
    // MARK: - Private
    
    private func sign(
        path: String,
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
            value: "\(method.lowercased()) \(path)",
            shouldIncludeInHeaders: false
        )
        subjects.append(requestSubject)
        
        self.sign(subjects: subjects, completion: completion)
    }
    
    private func sign(
        subjects: [SignatureSubject],
        completion: @escaping (RequestHeaders?) -> Void
        ) {
        
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
                completion(RequestHeaders())
                return
        }
        
        let hashedData = Common.SHA.sha256(data: signatureData)
        
        self.sign(hashedData: hashedData, completion: { [weak self] (signature) in
            guard let signatureBaseData = signature else {
                completion(RequestHeaders())
                return
            }
            
            let signatureBase64 = signatureBaseData.base64EncodedString()
            
            self?.keyDataProvider.getPublicKeyString(completion: { (publicKey) in
                guard let publicKey = publicKey else {
                    completion(RequestHeaders())
                    return
                }
                
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
                
                var headers = RequestHeaders()
                
                for subject in subjects where subject.shouldIncludeInHeaders {
                    headers[subject.key] = subject.value
                }
                
                headers["Authorization"] = authString
                
                completion(headers)
            })
        })
    }
    
    private func getSignablePathString(
        requestModel: JSONAPI.RequestSignParametersModel
        ) -> String {
        
        let baseUrlString = requestModel.baseUrl
        let urlString = requestModel.baseUrl/requestModel.path
        
        guard let urlRequest = requestModel.network.multiEncodedURLRequest(
            baseUrl: requestModel.baseUrl,
            path: requestModel.path,
            method: requestModel.method,
            queryItems: requestModel.queryItems,
            bodyParameters: requestModel.bodyParameters,
            headers: requestModel.headers
            ) else {
                return urlString
        }
        
        let encodedUrl = urlRequest.url?.absoluteString ?? urlString
        
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

open class RequestSignerBlockCallerJSONAPI: JSONAPI.RequestSignerProtocol {
    
    // MARK: - Public properties
    
    public let signingKey: ECDSA.KeyData
    public let onSignRequest: JSONAPI.SignRequestBlock
    
    public init(
        signingKey: ECDSA.KeyData,
        onSignRequest: @escaping JSONAPI.SignRequestBlock
        ) {
        
        self.signingKey = signingKey
        self.onSignRequest = onSignRequest
    }
    
    // MARK: - Public
    
    public static func getUnsafeSignRequestBlock() -> JSONAPI.SignRequestBlock {
        return { signingKey, request, completion in
            let keyDataProvider = UnsafeRequestSignKeyDataProvider(keyPair: signingKey)
            var requestSigner: JSONAPI.RequestSigner? = JSONAPI.RequestSigner(keyDataProvider: keyDataProvider)
            
            requestSigner?.sign(
                request: request,
                completion: { (headers) in
                    completion(headers)
                    requestSigner = nil
            })
        }
    }
    
    // MARK: - RequestSignerProtocol
    
    public func sign(
        request: JSONAPI.RequestSignParametersModel,
        completion: @escaping (RequestHeaders?) -> Void
        ) {
        
        self.onSignRequest(self.signingKey, request, completion)
    }
}

extension JSONAPI {
    
    public typealias RequestSigner = RequestSignerJSONAPI
    public typealias RequestSignerBlockCaller = RequestSignerBlockCallerJSONAPI
}

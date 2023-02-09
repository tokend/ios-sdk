import Foundation

/// Conatiner for errors that can be fetched from api
public struct ApiErrors: Decodable, Swift.Error, LocalizedError, CustomDebugStringConvertible {
    
    public let errors: [ApiError]
    
    // MARK: -
    
    public init(errors: [ApiError]) {
        self.errors = errors
    }
    
    // MARK: - Public
    
    /// Method checks if the object contains the error with given properties.
    /// - Parameters:
    ///   - status: The status of the error to be checked
    ///   - code: The code of the error to be checked
    ///   - detail: The detail of the error to be checked
    /// - Returns: `Bool`
    public func contains(
        status: String,
        code: String? = nil,
        detail: String? = nil
        ) -> Bool {
        
        return errors.contains {
            ($0.status == status)
                && ($0.code == code || code == nil)
                && ($0.detail == detail || detail == nil)
        }
    }
    
    /// Method finds and returns the first error with given properties, if it exists.
    /// - Parameters:
    ///   - status: The status of the error to be found
    ///   - code: The code of the error to be found
    /// - Returns: `ApiError?`
    public func firstErrorWith(
        status: String,
        code: String? = nil
        ) -> ApiError? {
        
        return self.errors.first(where: { (error) -> Bool in
            error.status == status && error.code == code
        })
    }
    
    // MARK: - Swift.Error
    
    public var errorDescription: String? {
        var description: String = ""
        
        if self.errors.count > 1 {
            description.append("Errors:")
        }
        
        for error in self.errors {
            description.append("\n\(error.localizedDescription)")
        }
        
        description = description.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return description
    }
    
    // MARK: - CustomDebugStringConvertible
    
    public var debugDescription: String {
        var errorsDescriptions: [String] = []
        
        for (index, error) in self.errors.enumerated() {
            let errorDescripion = error.debugDescription
            errorsDescriptions.append("\(index): \(DebugIndentedString(errorDescripion))")
        }
        
        let errorsFormattedDescription = DebugFormattedDescription(errorsDescriptions)
        
        var fields: [String] = []
        
        fields.append("errors: \(DebugIndentedString(errorsFormattedDescription))")
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

/// Error that can be fetched from api
public struct ApiError: Decodable, Swift.Error, LocalizedError, CustomDebugStringConvertible {
    
    public static let noInternetErrorCode: Int = 10000
    public static let requestSignErrorCode: Int = 1999
    public static let responseDecodeErrorCode: Int = 2999
    
    public let status: String
    public let code: String?
    public let title: String?
    public let detail: String?
    public let meta: JSON?
    
    public let horizonError: HorizonError?
    public let horizonErrorV2: HorizonErrorV2?
    public let nsError: NSError?
    
    public enum Status {
        static public let conflict          = "409"
        static public let forbidden         = "403"
        static public let notFound          = "404"
        static public let unauthorized      = "401"
        static public let unknown           = "-999"
        static public let urlEncodeFailed   = "999"
        static public let requestSignFailed = "\(requestSignErrorCode)"
        static public let responseDecodeFailed = "\(responseDecodeErrorCode)"
    }
    
    public enum Code {
        static public let notAllowed            = "not_allowed"
        static public let tfaRequired           = "tfa_required"
        static public let unknown               = "unknown"
        static public let verificationRequired  = "verification_required"
        static public let opOrderViolatesHardCap = "op_order_violates_hard_cap"
        static public let opSaleAlreadyEnded = "op_sale_already_ended"
        static public let opAssetPairNotTradable = "op_asset_pair_not_tradable"
    }
    
    public enum Title {
        static public let unknown           = "Unknown"
        static public let urlEncodeFailed   = "URL encode failed"
        static public let requestSignFailed = "Request sign failed"
        static public let responseDecodeFailed = "Response decode failed"
    }
    
    public enum CodingKeys: String, CodingKey {
        case status
        case code
        case title
        case detail
        case meta
    }
    
    public var tfaMeta: TFAMetaResponse? {
        guard let meta = self.meta else { return nil }
        
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: meta, options: []),
            let decoded = try? JSONDecoder().decode(TFAMetaResponse.self, from: jsonData) else {
                return nil
        }
        
        return decoded
    }
    
    // MARK: -
    
    public init(
        status: String,
        code: String?,
        title: String?,
        detail: String?,
        meta: JSON? = nil,
        horizonError: HorizonError? = nil,
        horizonErrorV2: HorizonErrorV2? = nil,
        nsError: NSError? = nil
        ) {
        
        self.status = status
        self.code = code
        self.title = title
        self.detail = detail
        self.meta = meta
        
        self.horizonError = horizonError
        self.horizonErrorV2 =  horizonErrorV2
        self.nsError = nsError
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.status = try container.decodeString(key: .status)
        self.code = container.decodeOptionalString(key: .code)
        self.title = container.decodeOptionalString(key: .title)
        self.detail = container.decodeOptionalString(key: .detail)
        self.meta = try container.decodeDictionaryIfPresent(JSON.self, forKey: .meta)
        
        self.horizonError = nil
        self.horizonErrorV2 = nil
        self.nsError = nil
    }
    
    // MARK: - LocalizedError
    
    public var errorDescription: String? {
        let description: String
        
        if let horrizonError = self.horizonError,
            let extras = horrizonError.extras,
            let messages = extras.resultCodes.messages {
            
            description = messages.joined(separator: "\n")
        } else if let horrizonErrorV2 = self.horizonErrorV2,
            let extras = horrizonErrorV2.meta.extras,
            let messages = extras.resultCodes.messages {
            
            description = messages.joined(separator: "\n")
        } else if let nsError = self.nsError {
            description = nsError.localizedDescription
        } else {
            var fields: [String] = []
            
            if let title = self.title {
                fields.append("\(title) \(self.status)")
            }
            if let detail = self.detail {
                fields.append(detail)
            }
            if let metaError = self.meta?["error"] as? String {
                fields.append("Error: \(metaError)")
            }
            
            if fields.count == 0 {
                fields.append("Error status: \(self.status)")
            }
            
            description = fields.joined(separator: " ")
        }
        
        return description
    }
    
    // MARK: - CustomDebugStringConvertible
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("status: \(self.status)")
        if let title = self.title {
            fields.append("title: \(title)")
        }
        if let detail = self.detail {
            fields.append("detail: \(detail)")
        }
        if let code = self.code {
            fields.append("code: \(code)")
        }
        
        if let horizonError = self.horizonError {
            let horizonErrorDescription = horizonError.debugDescription
            fields.append("HorizonError: \(DebugIndentedString(horizonErrorDescription))")
        }
        
        if let horizonErrorV2 = self.horizonErrorV2 {
            let horizonErrorDescription = horizonErrorV2.debugDescription
            fields.append("HorizonError: \(DebugIndentedString(horizonErrorDescription))")
        }
        
        if let meta = self.meta {
            let metaDescription = meta.debugDescription
            fields.append("TFAMeta: \(DebugIndentedString(metaDescription))")
        }
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}

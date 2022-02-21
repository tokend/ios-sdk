import Foundation

/// Struct containts data which identify api
public struct ApiConfiguration {
    
    /// API's URL. Trailing slash will be trimmed.
    public let urlString: String
    
    /// User network agent name.
    public let userAgent: String?
    
    // MARK: -
    
    public init(
        urlString: String,
        userAgent: String? = nil
        ) {
        
        self.urlString = urlString
        self.userAgent = userAgent
    }
}

/// Protocol provides up to date `ApiConfiguration` model
public protocol ApiConfigurationProviderProtocol {
    
    var apiConfiguration: ApiConfiguration { get }
}

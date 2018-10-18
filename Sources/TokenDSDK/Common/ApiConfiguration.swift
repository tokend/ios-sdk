import Foundation

/// Struct containts data which identify api
public struct ApiConfiguration {
    
    /// API's URL
    let urlString: String
    
    let userAgent: String
    
    public init(urlString: String, userAgent: String) {
        self.urlString = urlString
        self.userAgent = userAgent
    }
}

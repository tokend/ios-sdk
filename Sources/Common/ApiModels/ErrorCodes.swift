import Foundation

/// Error codes
public enum ErrorCodes: Int, LocalizedError {
    
    case noInternet = 10000
    case notFound = 404
    case requestBuildFailed = 1998
    case requestSignFailed = 1999
    case urlEncodeFailed = 999
    
    // MARK: - Public
    
    public var stringValue: String {
        return self.description
    }
    
    // MARK: - LocalizedError
    
    public var errorDescription: String {
        switch self {
            
        case .noInternet:
            return "No internet connection"
            
        case .notFound:
            return "Not found"
            
        case .requestBuildFailed:
            return "Request build failed"
            
        case .requestSignFailed:
            return "Request sign failed"
            
        case .urlEncodeFailed:
            return "URL encode failed"
        }
    }
}

// MARK: - CustomStringConvertible

extension ErrorCodes: CustomStringConvertible {
    
    public var description: String {
        return "\(self.rawValue)"
    }
}

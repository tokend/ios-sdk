import Foundation
import DLJSONAPI

extension JSONAPIError {
    
    /// Error returnt by APIs when request signing failed
    public static var failedToBuildRequest: Error {
        let error = ErrorCodes.requestBuildFailed
        return NSError(
            domain: "com.tokend.sdk.ios",
            code: error.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: error.description
            ]
        )
    }
    
    /// Error returnt by APIs when request signing failed
    public static var failedToSignRequest: Error {
        let error = ErrorCodes.requestSignFailed
        return NSError(
            domain: "com.tokend.sdk.ios",
            code: error.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: error.description
            ]
        )
    }
    
    /// Method checks if the object contains the error with given properties.
    /// - Parameters:
    ///   - status: The status of the error to be checked
    /// - Returns: `Bool`
    public func contains(status: String) -> Bool {
        let errorObjects: [ErrorObject]
        
        switch self {
            
        case .errors(let errors):
            errorObjects = errors
            
        case .serialization:
            return false
        }
        
        return errorObjects.contains(where: { (error) -> Bool in
            return error.status == status
        })
    }
    
    public func contains(operation: String) -> Bool {
        let errorObjects: [ErrorObject]
        
        switch self {
            
        case .errors(let errors):
            errorObjects = errors
            
        case .serialization:
            return false
        }
        
        return errorObjects.contains(where: { (error) -> Bool in
            let resultCodes = error.meta?.dictionary["resultCodes"] as? [String: Any]
            let operations = resultCodes?["operations"] as? [String]
            if let errorOperation = operations?.first(where: { $0 == operation }) {
                return errorOperation == operation
            }
            return false
        })
    }
}

extension Error {
    
    /// Method checks if the object contains the error with given properties.
    /// - Parameters:
    ///   - status: The status of the error to be checked
    /// - Returns: `Bool`
    public func contains(status: String) -> Bool {
        guard let jsonApiError = self as? JSONAPIError else { return false }
        
        return jsonApiError.contains(status: status)
    }
    
    public func contains(operation: String) -> Bool {
        guard let jsonApiError = self as? JSONAPIError else { return false }
        
        return jsonApiError.contains(operation: operation)
    }
}

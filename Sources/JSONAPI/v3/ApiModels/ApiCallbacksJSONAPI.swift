import Foundation

public struct ApiCallbacksJSONAPI {
    
    // MARK: - Public properties
    
    public let onUnathorizedRequest: (_ error: Error) -> Void
    
    // MARK: -
    
    public init(
        onUnathorizedRequest: @escaping (_ error: Error) -> Void
        ) {
        
        self.onUnathorizedRequest = onUnathorizedRequest
    }
}

extension JSONAPI {
    
    public typealias ApiCallbacks = ApiCallbacksJSONAPI
}

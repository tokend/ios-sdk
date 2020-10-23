import Foundation

public typealias TFARequiredHandler = ((_ tfaInput: ApiCallbacks.TFAInput, _ cancel: @escaping () -> Void) -> Void)

public struct ApiCallbacks {
    
    public let onTFARequired: TFARequiredHandler
    public let onUnathorizedRequest: (_ error: ApiErrors) -> Void
    
    // MARK: -
    
    public init(
        onTFARequired: @escaping TFARequiredHandler,
        onUnathorizedRequest: @escaping (_ error: ApiErrors) -> Void
        ) {
        
        self.onTFARequired = onTFARequired
        self.onUnathorizedRequest = onUnathorizedRequest
    }
}

extension ApiCallbacks {
    public struct TokenSignData {
        public let walletId: String
        public let keychainData: Data
        public let salt: Data
        public let token: String
        public let factorId: Int
    }
    
    public enum TFAInput {
        case password(
                tokenSignData: TokenSignData,
                inputCallback: (_ signedToken: String, _ completion: @escaping () -> Void) -> Void
             )
        case code(
                type: TFAMetaResponse.CodeBasedType,
                inputCallback: (_ code: String, _ completion: @escaping () -> Void) -> Void
             )
    }
}

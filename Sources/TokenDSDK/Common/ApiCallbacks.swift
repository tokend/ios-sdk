import Foundation

public typealias TFARequiredHandler = ((_ tfaInput: ApiCallbacks.TFAInput, _ cancel: @escaping () -> Void) -> Void)

public struct ApiCallbacks {
    public struct TokenSignData {
        public let walletId: String
        public let keychainData: Data
        public let salt: Data
        public let token: String
        public let factorId: Int
    }
    
    public enum TFAInput {
        case password(tokenSignData: TokenSignData, inputCallback: (_ signedToken: String) -> Void)
        case code(type: TFAMetaResponse.CodeBasedType, inputCallback: (_ code: String) -> Void)
    }
    
    public let onTFARequired: TFARequiredHandler
    
    // MARK: -
    
    public init(onTFARequired: @escaping TFARequiredHandler) {
        self.onTFARequired = onTFARequired
    }
}

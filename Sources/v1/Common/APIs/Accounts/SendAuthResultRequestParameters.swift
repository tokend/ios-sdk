import Foundation

public struct SendAuthResultRequestParameters {
    public let success: Bool
    public let walletId: String
    
    public init(
        success: Bool,
        walletId: String
        ) {
        
        self.success = success
        self.walletId = walletId
    }
}

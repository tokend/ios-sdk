import Foundation

/// Email verification model. Needed for email verification request.
public struct EmailVerification: Encodable {
    
    public let attributes: Attributes
    
    public struct Attributes: Encodable {
        
        public let token: String
    }
}

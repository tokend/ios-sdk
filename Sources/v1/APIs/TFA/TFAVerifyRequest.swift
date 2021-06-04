import Foundation

public struct TFAVerifyRequest: Encodable {
    
    public let attributes: Attributes
    
    public struct Attributes: Encodable {
        
        public let otp: String
        public let token: String
    }
}

import Foundation

public struct CreateUserModel: Encodable {
    
    public let attributes: Attributes
    
    public init(attributes: Attributes) {
        self.attributes = attributes
    }
    
    public struct Attributes: Encodable {
        
        public let type: UserType
        
        public init(type: UserType) {
            self.type = type
        }
        
        public enum UserType: Int, Encodable {
            case notVerified = 1
        }
    }
}

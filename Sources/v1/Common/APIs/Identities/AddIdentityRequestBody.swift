import Foundation

public struct AddIdentityRequestBody: Encodable {
    public let data: Data
    
    public struct Data: Encodable {
        public let attributes: Attributes
        
        public struct Attributes: Encodable {
            let phoneNumber: String
        }
    }
    
    public init(phoneNumber: String) {
        self.data = Data(
            attributes: .init(
                phoneNumber: phoneNumber
            )
        )
    }
}

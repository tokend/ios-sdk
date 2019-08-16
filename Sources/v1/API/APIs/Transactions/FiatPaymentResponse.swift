import Foundation

/// Transaction response model
public struct FiatPaymentResponse: Decodable {
    
    // MARK: - Public properties
    
    public let data: Data
    
    public struct Data: Decodable {
        public let attributes: Attributes
        
        public struct Attributes: Decodable {
            public let payUrl: String
        }
    }
}

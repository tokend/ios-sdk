import Foundation

public struct TFACreateFactorModel: Encodable {
    
    public let type: String
}

public struct TFACreateFactorResponse: Decodable {
    
    public let id: String
    public let type: String
    public let attributes: Attributes
    
    public struct Attributes: Decodable {
        
        public let secret: String
        public let seed: String
    }
}

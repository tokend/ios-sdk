import Foundation

public struct TFAUpdateFactorModel: Encodable {
    
    public let attributes: Attributes
    
    public struct Attributes: Encodable {
        
        public let priority: Int
    }
}

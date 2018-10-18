import Foundation

public struct GetWalletKDFResponse: Decodable {
    
    public let attributes: Attributes
    public let id: String
    public let type: String
    
    public struct Attributes: Decodable {
        public let algorithm: String
        public let bits: Int64
        public let n: UInt64
        public let p: UInt32
        public let r: UInt32
        public let salt: String
    }
}

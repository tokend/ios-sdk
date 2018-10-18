import Foundation

/// Response model for `GetKDFParamsRequest` api request
public struct GetKDFParamsResponse: Decodable {
    
    public let attributes: Attributes
    public let id: String
    public let type: String
    
    public struct Attributes: Decodable {
        
        /// KDF algorithm.
        /// - Note: Only `Scrypt` is supported currently.
        public let algorithm: String
        public let bits: Int64
        public let n: UInt64
        public let p: UInt32
        public let r: UInt32
    }
}

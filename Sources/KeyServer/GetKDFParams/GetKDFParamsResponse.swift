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

extension KDFParams {
    
    public static func fromResponse(
        _ response: GetKDFParamsResponse
    ) -> KDFParams {

        return KDFParams(
            algorithm: response.attributes.algorithm,
            bits: response.attributes.bits,
            id: response.id,
            n: response.attributes.n,
            p: response.attributes.p,
            r: response.attributes.r,
            type: response.type
        )
    }
}

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

extension WalletKDFParams {
    
    public static func fromResponse(_ response: GetWalletKDFResponse) -> WalletKDFParams? {
        guard let salt = response.attributes.salt.dataFromBase64 else {
            return nil
        }
        
        return WalletKDFParams(
            kdfParams: KDFParams.fromResponse(response),
            salt: salt
        )
    }
}

extension KDFParams {
    
    public static func fromResponse(_ response: GetWalletKDFResponse) -> KDFParams {
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

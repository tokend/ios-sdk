import Foundation

public struct AccountBusinessesResponse: Decodable {
    
    public let data: [Data]
}

extension AccountBusinessesResponse {
    
    public struct Data: Decodable {
        public let id: UInt64
        public let type: String
        public let attributes: Attributes
    }
}

extension AccountBusinessesResponse.Data {
    
    public struct Attributes: Decodable {
        public let name: String
        public let accountId: String
        public let logoLink: String
    }
}

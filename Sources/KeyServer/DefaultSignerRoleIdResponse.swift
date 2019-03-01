import Foundation

public struct DefaultSignerRoleIdResponse: Decodable {
    public let roleId: UInt32
    
    enum CodingKeys: String, CodingKey {
        case roleId = "uint32Value"
    }
}

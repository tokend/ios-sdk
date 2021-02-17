// Auto-generated code. Do not edit.

import Foundation

// MARK: - Time

extension MunaBooking {
public struct Time: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case hours
        case minutes
    }
    
    // MARK: Attributes
    
    public let hours: Int32
    public let minutes: Int32

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.hours = try container.decode(Int32.self, forKey: .hours)
        self.minutes = try container.decode(Int32.self, forKey: .minutes)
    }

}
}

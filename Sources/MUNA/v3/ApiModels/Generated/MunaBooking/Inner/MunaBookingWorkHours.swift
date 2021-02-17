// Auto-generated code. Do not edit.

import Foundation

// MARK: - WorkHours

extension MunaBooking {
public struct WorkHours: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case end
        case start
    }
    
    // MARK: Attributes
    
    public let end: Time
    public let start: Time

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.end = try container.decode(Time.self, forKey: .end)
        self.start = try container.decode(Time.self, forKey: .start)
    }

}
}

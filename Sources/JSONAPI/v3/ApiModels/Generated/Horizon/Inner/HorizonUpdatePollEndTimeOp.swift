// Auto-generated code. Do not edit.

import Foundation

// MARK: - UpdatePollEndTimeOp

extension Horizon {
public struct UpdatePollEndTimeOp: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case newEndTime
    }
    
    // MARK: Attributes
    
    public let newEndTime: Date

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.newEndTime = try container.decodeDateString(key: .newEndTime)
    }

}
}

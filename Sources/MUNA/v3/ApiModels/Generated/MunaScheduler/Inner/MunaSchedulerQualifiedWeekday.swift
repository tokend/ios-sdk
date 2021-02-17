// Auto-generated code. Do not edit.

import Foundation

// MARK: - QualifiedWeekday

extension MunaScheduler {
public struct QualifiedWeekday: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case n
        case wd
    }
    
    // MARK: Attributes
    
    public let n: Int32
    public let wd: Int32

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.n = try container.decode(Int32.self, forKey: .n)
        self.wd = try container.decode(Int32.self, forKey: .wd)
    }

}
}

// Auto-generated code. Do not edit.

import Foundation

// MARK: - Stage

extension DMS {
public struct Stage: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case completionRule
        case dateDue
        case dateIn
        case duration
        case orderNumber
        case origDateDue
        case rejectionPolicy
        case steps
    }
    
    // MARK: Attributes
    
    public let completionRule: Int32?
    public let dateDue: Date?
    public let dateIn: Date?
    public let duration: Int32?
    public let orderNumber: Int32?
    public let origDateDue: Date?
    public let rejectionPolicy: Int32?
    public let steps: [Step]?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.completionRule = try? container.decode(Int32.self, forKey: .completionRule)
        self.dateDue = try? container.decode(Date.self, forKey: .dateDue)
        self.dateIn = try? container.decode(Date.self, forKey: .dateIn)
        self.duration = try? container.decode(Int32.self, forKey: .duration)
        self.orderNumber = try? container.decode(Int32.self, forKey: .orderNumber)
        self.origDateDue = try? container.decode(Date.self, forKey: .origDateDue)
        self.rejectionPolicy = try? container.decode(Int32.self, forKey: .rejectionPolicy)
        self.steps = try? container.decode([Step].self, forKey: .steps)
    }

}
}

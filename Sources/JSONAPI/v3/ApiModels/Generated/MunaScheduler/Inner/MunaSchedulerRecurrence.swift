// Auto-generated code. Do not edit.

import Foundation

// MARK: - Recurrence

extension MunaScheduler {
public struct Recurrence: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case dtstart
        case exDates
        case floatingLocation
        case rDates
        case rRules
    }
    
    // MARK: Attributes
    
    public let dtstart: Date
    public let exDates: [Date]?
    public let floatingLocation: Bool?
    public let rDates: [Date]?
    public let rRules: [RecurrenceRule]

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dtstart = try container.decode(Date.self, forKey: .dtstart)
        self.exDates = try? container.decode([Date].self, forKey: .exDates)
        self.floatingLocation = try? container.decode(Bool.self, forKey: .floatingLocation)
        self.rDates = try? container.decode([Date].self, forKey: .rDates)
        self.rRules = try container.decode([RecurrenceRule].self, forKey: .rRules)
    }

}
}

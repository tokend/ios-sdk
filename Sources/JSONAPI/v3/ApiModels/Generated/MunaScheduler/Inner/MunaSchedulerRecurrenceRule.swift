// Auto-generated code. Do not edit.

import Foundation

// MARK: - RecurrenceRule

extension MunaScheduler {
public struct RecurrenceRule: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case byHours
        case byMinutes
        case byMonthDays
        case byMonths
        case bySeconds
        case bySetPos
        case byWeekNumbers
        case byWeekdays
        case byYearDays
        case count
        case dtstart
        case frequency
        case interval
        case until
        case untilFloating
    }
    
    // MARK: Attributes
    
    public let byHours: [Int32]
    public let byMinutes: [Int32]
    public let byMonthDays: [Int32]
    public let byMonths: [Int32]
    public let bySeconds: [Int32]
    public let bySetPos: [Int32]
    public let byWeekNumbers: [Int32]
    public let byWeekdays: [QualifiedWeekday]
    public let byYearDays: [Int32]
    public let count: UInt64?
    public let dtstart: Date
    public let frequency: Int32
    public let interval: Int32?
    public let until: Date?
    public let untilFloating: Bool?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.byHours = try container.decode([Int32].self, forKey: .byHours)
        self.byMinutes = try container.decode([Int32].self, forKey: .byMinutes)
        self.byMonthDays = try container.decode([Int32].self, forKey: .byMonthDays)
        self.byMonths = try container.decode([Int32].self, forKey: .byMonths)
        self.bySeconds = try container.decode([Int32].self, forKey: .bySeconds)
        self.bySetPos = try container.decode([Int32].self, forKey: .bySetPos)
        self.byWeekNumbers = try container.decode([Int32].self, forKey: .byWeekNumbers)
        self.byWeekdays = try container.decode([QualifiedWeekday].self, forKey: .byWeekdays)
        self.byYearDays = try container.decode([Int32].self, forKey: .byYearDays)
        self.count = try? container.decode(UInt64.self, forKey: .count)
        self.dtstart = try container.decode(Date.self, forKey: .dtstart)
        self.frequency = try container.decode(Int32.self, forKey: .frequency)
        self.interval = try? container.decode(Int32.self, forKey: .interval)
        self.until = try? container.decode(Date.self, forKey: .until)
        self.untilFloating = try? container.decode(Bool.self, forKey: .untilFloating)
    }

}
}

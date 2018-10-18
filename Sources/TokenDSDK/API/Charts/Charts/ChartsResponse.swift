import Foundation

public typealias ChartsResponse = [String: [ChartResponse]]

public struct ChartResponse: Decodable {
    
    public let timestamp: Date
    public let value: Decimal
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.timestamp = try container.decodeDateString(
            key: .timestamp,
            dateFormatter: DateFormatters.rfc3339DateFormatter
        )
        self.value = try container.decodeDecimalString(key: .value)
    }
}

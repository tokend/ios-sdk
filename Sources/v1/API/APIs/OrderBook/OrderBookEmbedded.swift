import Foundation

public struct OrderBookEmbedded<RecordType: Decodable>: Decodable {
    
    public enum OrderBookEmbeddedCodingKeys: String, CodingKey {
        case records
    }
    
    // MARK: - Public properties
    
    public let records: [RecordType]
    
    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OrderBookEmbeddedCodingKeys.self)
        
        guard let recordsData = try container.decodeArrayIfPresent([Any].self, forKey: .records) as? [JSON] else {
            throw DecodingError.dataCorruptedError(
                forKey: OrderBookEmbeddedCodingKeys.records,
                in: container,
                debugDescription: "No records"
            )
        }
        
        let records: [RecordType] = recordsData.compactMap { (recordData) -> RecordType? in
            if let response = try? RecordType.decode(from: recordData) {
                return response
            }
            print("unparsed base: \(recordData)")
            return nil
        }
        
        self.records = records
    }
}

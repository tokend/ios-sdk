import Foundation

public struct OrderBookEmbedded {
    
    public let records: [OrderBookResponse]
}

extension OrderBookEmbedded: Decodable {
    enum OrderBookEmbeddedCodingKeys: String, CodingKey {
        case records
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OrderBookEmbeddedCodingKeys.self)
        
        guard let recordsData = try container.decodeArrayIfPresent([Any].self, forKey: .records) as? [JSON] else {
            throw DecodingError.dataCorruptedError(
                forKey: OrderBookEmbeddedCodingKeys.records,
                in: container,
                debugDescription: "No records"
            )
        }
        
        let records: [OrderBookResponse] = recordsData.compactMap { (recordData) -> OrderBookResponse? in
            if let response = try? OrderBookResponse.decode(from: recordData) {
                return response
            }
            print("unparsed base: \(recordData)")
            return nil
        }
        
        self.records = records
    }
}

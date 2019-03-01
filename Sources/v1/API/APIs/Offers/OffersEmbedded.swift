import Foundation

public struct OffersEmbedded {
    
    public let records: [OfferResponse]
}

extension OffersEmbedded: Decodable {
    enum OffersEmbeddedCodingKeys: String, CodingKey {
        case records
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OffersEmbeddedCodingKeys.self)
        
        guard let recordsData = try container.decodeArrayIfPresent([Any].self, forKey: .records) as? [JSON] else {
            throw DecodingError.dataCorruptedError(
                forKey: OffersEmbeddedCodingKeys.records,
                in: container,
                debugDescription: "No records"
            )
        }
        
        let records: [OfferResponse] = recordsData.compactMap { (recordData) -> OfferResponse? in
            if let response = try? OfferResponse.decode(from: recordData) {
                return response
            } else {
                print("unparsed base: \(recordData)")
            }
            return nil
        }
        
        self.records = records
    }
}

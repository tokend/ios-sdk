// Auto-generated code. Do not edit.

import Foundation

// MARK: - PayloadDetails

extension MunaBooking {
public struct PayloadDetails: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case capacity
        case price
        case workDays
    }
    
    // MARK: Attributes
    
    public let capacity: Int32
    public let price: PriceDetails
    public let workDays: [String: WorkHours]

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.capacity = try container.decode(Int32.self, forKey: .capacity)
        self.price = try container.decode(PriceDetails.self, forKey: .price)
        self.workDays = try container.decode([String: WorkHours].self, forKey: .workDays)
    }

}
}

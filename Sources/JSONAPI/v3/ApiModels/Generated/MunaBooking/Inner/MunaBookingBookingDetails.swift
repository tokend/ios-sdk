// Auto-generated code. Do not edit.

import Foundation

// MARK: - BookingDetails

extension MunaBooking {
public struct BookingDetails: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case availableFrom
        case availableTill
        case cancelTill
        case confirmationTypes
        case maxDuration
        case minDuration
        case refund
        case specificDetails
    }
    
    // MARK: Attributes
    
    public let availableFrom: String?
    public let availableTill: String?
    public let cancelTill: String?
    public let confirmationTypes: [Int32]
    public let maxDuration: String
    public let minDuration: String
    public let refund: Decimal
    public let specificDetails: [String: PayloadDetails]

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.availableFrom = try? container.decode(String.self, forKey: .availableFrom)
        self.availableTill = try? container.decode(String.self, forKey: .availableTill)
        self.cancelTill = try? container.decode(String.self, forKey: .cancelTill)
        self.confirmationTypes = try container.decode([Int32].self, forKey: .confirmationTypes)
        self.maxDuration = try container.decode(String.self, forKey: .maxDuration)
        self.minDuration = try container.decode(String.self, forKey: .minDuration)
        self.refund = try container.decodeDecimalString(key: .refund)
        self.specificDetails = try container.decode([String: PayloadDetails].self, forKey: .specificDetails)
    }

}
}

import Foundation

/// Result page wrapper model for embedded results.
public struct RequestResultPage<E: Decodable>: Decodable {
    
    public let embedded: E
    
    public enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

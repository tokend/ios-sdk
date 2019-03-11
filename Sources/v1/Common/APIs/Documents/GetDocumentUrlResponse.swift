import Foundation

public struct GetDocumentUrlResponse: Decodable {
    
    // MARK: - Public properties
    
    public let type: String
    public let attributes: Attributes
}

extension GetDocumentUrlResponse {
    
    public struct Attributes: Decodable {
        
        public let url: String
    }
}

import Foundation

public struct UploadBlobResponse: Decodable {
    
    public let id: String
    public let type: String
    public let attributes: Attributes
}

extension UploadBlobResponse {
    
    public struct Attributes: Decodable {
        
        public let value: String
    }
}

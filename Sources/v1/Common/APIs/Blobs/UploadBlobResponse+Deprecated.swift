import Foundation

@available(*, deprecated, renamed: "BlobResponse")
public struct UploadBlobResponse: Decodable {
    
    public let id: String
    public let type: String
    public let attributes: Attributes
}

@available(*, deprecated, renamed: "BlobResponse")
extension UploadBlobResponse {
    
    public struct Attributes: Decodable {
        
        public let value: String
    }
}

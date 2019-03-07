import Foundation

public enum DocumentUploadOption {
    
    case data(data: Data, meta: MetaInfo)
    case stream(stream: InputStream, length: UInt64, meta: MetaInfo)
}

extension DocumentUploadOption {
    
    public struct MetaInfo {
        
        public let name: String
        public let fileName: String
        public let mimeType: String
        
        public init(
            name: String,
            fileName: String,
            mimeType: String
            ) {
            
            self.name = name
            self.fileName = fileName
            self.mimeType = mimeType
        }
    }
}

import Foundation

/// Option to upload document.
public enum DocumentUploadOption {
    
    /// Option to attach data from memory.
    case data(data: Data, meta: MetaInfo)
    
    /// Option to provide data stream.
    case stream(stream: InputStream, length: UInt64, meta: MetaInfo)
}

extension DocumentUploadOption {
    
    public struct MetaInfo {
        
        public let fileName: String
        public let mimeType: String
        
        public init(
            fileName: String,
            mimeType: String
            ) {
            
            self.fileName = fileName
            self.mimeType = mimeType
        }
    }
}

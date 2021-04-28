// Auto-generated code. Do not edit.

import Foundation

// MARK: - CreateWorkflowSupplementaryFile

extension DMS {
public struct CreateWorkflowSupplementaryFile: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case comment
        case file
        case fileChanges
        case fileName
    }
    
    // MARK: Attributes
    
    public let comment: String?
    public let file: [String: Any]?
    public let fileChanges: [String: Any]?
    public let fileName: String?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.comment = try? container.decode(String.self, forKey: .comment)
        self.file = try? container.decodeDictionary([String: Any].self, forKey: .file)
        self.fileChanges = try? container.decodeDictionary([String: Any].self, forKey: .fileChanges)
        self.fileName = try? container.decode(String.self, forKey: .fileName)
    }

}
}

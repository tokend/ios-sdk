// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DocumentsResource

extension DMS {
open class DocumentsResource: Resource {
    
    open override class var resourceType: String {
        return "documents"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case additionalNotes
        case area
        case confidential
        case dateModified
        case dateUploaded
        case discipline
        case documentNo
        case dueDate
        case file
        case fileChanges
        case forHandover
        case locked
        case noLongerInUse
        case phase
        case printSize
        case reviewSource
        case reviewStatus
        case revision
        case revisionDate
        case status
        case subarea
        case title
        case type
        case version
        
        // relations
        case project
        case uploadedBy
    }
    
    // MARK: Attributes
    
    open var additionalNotes: String {
        return self.stringOptionalValue(key: CodingKeys.additionalNotes) ?? ""
    }
    
    open var area: String {
        return self.stringOptionalValue(key: CodingKeys.area) ?? ""
    }
    
    open var confidential: Bool {
        return self.boolOptionalValue(key: CodingKeys.confidential) ?? false
    }
    
    open var dateModified: Date? {
        return self.dateOptionalValue(key: CodingKeys.dateModified)
    }
    
    open var dateUploaded: Date {
        return self.dateOptionalValue(key: CodingKeys.dateUploaded) ?? Date()
    }
    
    open var discipline: Int32? {
        return self.int32OptionalValue(key: CodingKeys.discipline)
    }
    
    open var documentNo: String {
        return self.stringOptionalValue(key: CodingKeys.documentNo) ?? ""
    }
    
    open var dueDate: Date {
        return self.dateOptionalValue(key: CodingKeys.dueDate) ?? Date()
    }
    
    open var file: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.file) ?? [:]
    }
    
    open var fileChanges: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.fileChanges)
    }
    
    open var forHandover: Bool {
        return self.boolOptionalValue(key: CodingKeys.forHandover) ?? false
    }
    
    open var locked: Bool {
        return self.boolOptionalValue(key: CodingKeys.locked) ?? false
    }
    
    open var noLongerInUse: Bool {
        return self.boolOptionalValue(key: CodingKeys.noLongerInUse) ?? false
    }
    
    open var phase: String {
        return self.stringOptionalValue(key: CodingKeys.phase) ?? ""
    }
    
    open var printSize: String {
        return self.stringOptionalValue(key: CodingKeys.printSize) ?? ""
    }
    
    open var reviewSource: String? {
        return self.stringOptionalValue(key: CodingKeys.reviewSource)
    }
    
    open var reviewStatus: Int32? {
        return self.int32OptionalValue(key: CodingKeys.reviewStatus)
    }
    
    open var revision: String {
        return self.stringOptionalValue(key: CodingKeys.revision) ?? ""
    }
    
    open var revisionDate: Date {
        return self.dateOptionalValue(key: CodingKeys.revisionDate) ?? Date()
    }
    
    open var status: Int32 {
        return self.int32OptionalValue(key: CodingKeys.status) ?? 0
    }
    
    open var subarea: String {
        return self.stringOptionalValue(key: CodingKeys.subarea) ?? ""
    }
    
    open var title: String {
        return self.stringOptionalValue(key: CodingKeys.title) ?? ""
    }
    
    open var attributesType: Int32 {
        return self.int32OptionalValue(key: CodingKeys.type) ?? 0
    }
    
    open var version: Int32 {
        return self.int32OptionalValue(key: CodingKeys.version) ?? 0
    }
    
    // MARK: Relations
    
    open var project: DMS.ProjectsResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.project)
    }
    
    open var uploadedBy: DMS.UserResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.uploadedBy)
    }
    
}
}

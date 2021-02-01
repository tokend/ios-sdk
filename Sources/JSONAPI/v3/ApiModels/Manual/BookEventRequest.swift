import Foundation

// MARK: - BookEventRequest

struct BookEventRequest: Encodable {
    
    let data: Data
}

extension BookEventRequest {
    
    struct Data: Encodable {
        let confirmationType: Int
        let state: State
        let details: Details
        let source: String
        let startTime: String
        let endTime: String
        let participants: Int
        let payload: String
    }
}

extension BookEventRequest {
    
    struct State: Encodable {
        let name: String
        let value: Int
    }
}

extension BookEventRequest {
    
    struct Details: Encodable {
        let additionalInfo: String?
        let address: String
        let resultType: Int
        let hospitalId: String
        let testId: String
        let testType: Int
        let documents: Documents
    }
}

extension BookEventRequest {
    
    struct Documents: Encodable {
        let additionalPhoto: BlobResponse.BlobContent.Attachment?
    }
}

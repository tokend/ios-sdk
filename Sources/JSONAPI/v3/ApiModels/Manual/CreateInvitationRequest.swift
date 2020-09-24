import Foundation

// MARK: - CreateInvitationRequest

struct CreateInvitationRequest: Encodable {
    
    let data: Data
}

extension CreateInvitationRequest {
    
    struct Data: Encodable {
        
        let attributes: Attributes
        let relationships: Relationships
    }
}

extension CreateInvitationRequest {
    
    struct Attributes: Encodable {
        
        let details: Details
        let from: String
        let to: String
    }
    
    struct Details: Encodable {
        
        let addressDetails: String?
        let personalNote: String?
    }
    
    struct State: Encodable {
        let value: Int
        let name: String
    }
}

extension CreateInvitationRequest {
    
    struct Relationships: Encodable {
        
        let host: RelationshipsData
        let guest: RelationshipsData
        let place: RelationshipsData
    }
    
    struct RelationshipsData: Encodable {
        
        let data: RelationshipsDataId
    }
    
    struct RelationshipsDataId: Encodable {
        
        let id: String
    }
}

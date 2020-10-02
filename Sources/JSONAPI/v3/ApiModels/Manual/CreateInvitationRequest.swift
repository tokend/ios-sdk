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
}

extension CreateInvitationRequest.Attributes {
    
    struct Details: Encodable {
        
        let addressDetails: String?
        let personalNote: String?
    }
}

extension CreateInvitationRequest {
    
    struct Relationships: Encodable {
        
        let host: User
        let guest: User
        let place: Place
    }
}

extension CreateInvitationRequest.Relationships {
    
    struct User: Encodable {
        
        let data: Data
    }
}

extension CreateInvitationRequest.Relationships {
    
    struct Place: Encodable {
        
        let data: Data
    }
}

extension CreateInvitationRequest.Relationships {
    
    struct Data: Encodable {
        
        let id: String
    }
}

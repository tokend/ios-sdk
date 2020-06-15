import Foundation

// MARK: - ManyUsersRequest

struct ManyUsersRequest: Encodable {

    let data: Data
}

extension ManyUsersRequest {

    struct Data: Encodable {

        let relationships: Relationships
    }
}

extension ManyUsersRequest.Data {

    struct Relationships: Encodable {

        let users: Users
    }
}

extension ManyUsersRequest.Data.Relationships {

    struct Users: Encodable {

        let data: [Data]
    }
}

extension ManyUsersRequest.Data.Relationships.Users {

    struct Data: Encodable {
        
        let id: String
    }
}

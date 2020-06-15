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

        let users: [User]
    }
}

extension ManyUsersRequest.Data.Relationships {

    struct User: Encodable {

        let id: String
    }
}

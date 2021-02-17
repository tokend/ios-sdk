import Foundation

// MARK: - FriendMultipleRequest

struct FriendMultipleRequest: Encodable {

    let data: Data
}

extension FriendMultipleRequest {

    struct Data: Encodable {

        let type: String = "friend-multiple-request"
        let relationships: Relationships
    }
}

extension FriendMultipleRequest.Data {

    struct Relationships: Encodable {

        let newFriends: NewFriends
    }
}

extension FriendMultipleRequest.Data.Relationships {

    struct NewFriends: Encodable {

        let data: [NewFriend]
    }
}

extension FriendMultipleRequest.Data.Relationships.NewFriends {

    struct NewFriend: Encodable {

        let id: String
        let type: String = "identifiers"
    }
}

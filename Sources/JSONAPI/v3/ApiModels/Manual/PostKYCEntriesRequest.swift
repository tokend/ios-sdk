import Foundation

// MARK: - PostKYCEntriesRequest

struct PostKYCEntriesRequest: Encodable {

    let data: Data
}

extension PostKYCEntriesRequest {

    struct Data: Encodable {

        let type: String = "accounts"
        let relationships: Relationships
    }
}

extension PostKYCEntriesRequest.Data {

    struct Relationships: Encodable {

        let accounts: Accounts
    }
}

extension PostKYCEntriesRequest.Data.Relationships {

    struct Accounts: Encodable {

        let data: [Data]
    }
}

extension PostKYCEntriesRequest.Data.Relationships.Accounts {

    struct Data: Encodable {

        let id: String
        let type: String = "accounts"
    }
}

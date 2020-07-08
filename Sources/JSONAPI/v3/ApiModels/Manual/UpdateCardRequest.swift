import Foundation

// MARK: - UpdateCardRequest

struct UpdateCardRequest: Encodable {

    let data: Data
}

extension UpdateCardRequest {

    struct Data: Encodable {

        let type: String = "update-card-request"
        let attributes: Attributes
        let relationships: Relationships
    }
}

extension UpdateCardRequest.Data {

    struct Attributes: Encodable { }
}

extension UpdateCardRequest.Data {

    struct Relationships: Encodable {

        let bindBalances: Balances?
        let unbindBalances: Balances?
    }
}

extension UpdateCardRequest.Data.Relationships {

    struct Balances: Encodable {

        let data: [Balance]
    }
}

extension UpdateCardRequest.Data.Relationships.Balances {

    struct Balance: Encodable {

        let type: String = "balances"
        let id: String
    }
}

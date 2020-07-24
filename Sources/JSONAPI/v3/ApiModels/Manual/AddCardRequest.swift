import Foundation

// MARK: - AddCardRequest

struct AddCardRequest: Encodable {

    let data: Data
    let included: [Included]
}

extension AddCardRequest {

    struct Data: Encodable {

        let type: String = "add-card-request"
        let attributes: Attributes
        let relationships: Relationships
    }
}

extension AddCardRequest.Data {

    struct Attributes: Encodable {

        let cardNumber: String
        let details: Details
    }
}

extension AddCardRequest.Data.Attributes {

    struct Details: Encodable {

        let name: String
        let isPhysical: Bool
        let expirationYear: Int
        let expirationMonth: Int
        let design: String
        let isActivated: Bool
    }
}

extension AddCardRequest.Data {

    struct Relationships: Encodable {

        let owner: Owner
        let balances: Balances
        let securityDetails: SecurityDetails
    }
}

extension AddCardRequest.Data.Relationships {

    struct Owner: Encodable {

        let data: AccountsResource
    }
}

extension AddCardRequest.Data.Relationships {

    struct Balances: Encodable {

        let data: [BalancesResource]
    }
}

extension AddCardRequest.Data.Relationships {

    struct SecurityDetails: Encodable {

        let data: Data
    }
}

extension AddCardRequest.Data.Relationships.SecurityDetails {

    struct Data: Encodable {

        let id: String = "1"
        let type: String = "cards-security-details"
    }
}

extension AddCardRequest {

    struct Included: Encodable {

        let id: String = "1"
        let type: String = "cards-security-details"
        let relationships: Relationships
    }
}


extension AddCardRequest.Included {

    struct Relationships: Encodable {

        let card: Card
    }
}

extension AddCardRequest.Included.Relationships {

    struct Card: Encodable {

        let data: Data
    }
}

extension AddCardRequest.Included.Relationships.Card {

    struct Data: Encodable {

        let id: String
    }
}

import Foundation

// MARK: - RecordPaymentRequest

struct RecordPaymentRequest: Encodable {

    let data: Data
}

extension RecordPaymentRequest {

    struct Data: Encodable {

        let type: String = "record-payment-request"
        let attributes: Attributes
        let relationships: Relationships
    }
}

extension RecordPaymentRequest.Data {

    struct Attributes: Encodable {

        let createdAt: TimeInterval
    }
}

extension RecordPaymentRequest.Data {

    struct Relationships: Encodable {

        let source: Account
        let destination: Account
        let destinationCard: Card
    }
}

extension RecordPaymentRequest.Data.Relationships {

    struct Account: Encodable {

        let data: AccountsResource
    }
}

extension RecordPaymentRequest.Data.Relationships {

    struct Card: Encodable {

        let data: Data
    }
}

extension RecordPaymentRequest.Data.Relationships.Card {

    struct Data: Encodable {

        let id: String
        let type: String = "cards"
    }
}

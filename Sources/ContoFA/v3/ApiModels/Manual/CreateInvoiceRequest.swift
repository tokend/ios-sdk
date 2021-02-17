import Foundation

// MARK: - CreateInvoiceRequest

struct CreateInvoiceRequest: Encodable {

    let data: Data
}

extension CreateInvoiceRequest {

    struct Data: Encodable {

        let type: String = "invoices"
        let attributes: Attributes
        let relationships: Relationships
    }
}

extension CreateInvoiceRequest.Data {

    struct Attributes: Encodable {

        let amount: String
        let subject: String
    }
}

extension CreateInvoiceRequest.Data {

    struct Relationships: Encodable {

        let requestor: Relation
        let target: Relation
        let asset: Relation
        let destinationCard: Relation
    }
}

extension CreateInvoiceRequest.Data.Relationships {

    struct Relation: Encodable {

        let data: Data
    }
}

extension CreateInvoiceRequest.Data.Relationships.Relation {

    struct Data: Encodable {

        let id: String
        let type: String
    }
}

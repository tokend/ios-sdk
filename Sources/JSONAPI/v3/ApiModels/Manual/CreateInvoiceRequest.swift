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

        let requestor: Data
        let target: Data
        let asset: Data
        let destinationCard: Data
    }
}

extension CreateInvoiceRequest.Data.Relationships {

    struct Data: Encodable {

        let id: String
        let type: String
    }
}

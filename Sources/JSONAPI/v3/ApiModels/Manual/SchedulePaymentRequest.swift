import Foundation

// MARK: - SchedulePaymentRequest

struct SchedulePaymentRequest: Encodable {

    let data: Data
}

extension SchedulePaymentRequest {

    struct Data: Encodable {

        let type: String = "schedule-payments-request"
        let attributes: Attributes
        let relationships: Relationships
    }
}

extension SchedulePaymentRequest {

    struct Attributes: Encodable {

        let destinationType: DestinationType
        let amount: String
        let rRule: String
        let sendImmediately: Bool
        let subject: String
    }
}

extension SchedulePaymentRequest.Attributes {

    struct DestinationType: Encodable {

        let value: Int
        let name: String
    }
}

extension SchedulePaymentRequest {

    struct Relationships: Encodable {

        let sourceAccount: Data
        let sourceBalance: Data
        let sourceCard: Data
        let destinationCard: Data?
        let destinationBalance: Data
    }
}

extension SchedulePaymentRequest.Relationships {

    struct Data: Encodable {

        let id: String
        let type: String
    }
}

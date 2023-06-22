import Foundation

struct InitPlaidKycRequest: Encodable {
    let data: InitPlaidKycRequestData
}

struct InitPlaidKycRequestData: Encodable {
    let type: String
    let attributes: InitPlaidKycRequestDataAttributes
    
    init(
        type: String = "start_kyc",
        attributes: InitPlaidKycRequestDataAttributes
    ) {
        self.type = type
        self.attributes = attributes
    }
}

struct InitPlaidKycRequestDataAttributes: Encodable {
    let account_id: String
    let email: String
}


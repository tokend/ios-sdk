import Foundation

struct InitPlaidKycRequest: Encodable {
    let accountId: String
    let email: String
}

import Foundation

// MARK: - SubmitTransactionRequest

struct SubmitTransactionRequest: Encodable {

    let tx: String
    let waitForIngest: Bool
}

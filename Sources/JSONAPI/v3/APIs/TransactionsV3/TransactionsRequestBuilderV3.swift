import Foundation

public class TransactionsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {

    // MARK: - Private properties

    private let transactions: String = "transactions"

    // MARK: - Public

    /// Builds request to submit transaction
    public func buildSubmitTransactionRequest(
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = self.v3/self.transactions

        self.buildRequest(
            .simpleBody(
                path: path,
                method: .post,
                bodyParameters: bodyParameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

import Foundation
import DLJSONAPI

public class TransactionsApiV3: JSONAPI.BaseApi {

    // MARK: - Public properties

    public let requestBuilder: TransactionsRequestBuilderV3

    // MARK: -

    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = .init(
            builderStack: .fromApiStack(apiStack)
        )

        super.init(apiStack: apiStack)
    }

    // MARK: - Public

    @discardableResult
    public func requestSubmitTransaction(
        envelope: String,
        waitForIngest: Bool,
        completion: @escaping (_ result: RequestSingleResult<Horizon.TransactionResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        let request: SubmitTransactionRequest = .init(
            tx: envelope,
            waitForIngest: waitForIngest
        )

        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }

        self.requestBuilder.buildSubmitTransactionRequest(
            bodyParameters: encodedRequest,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestSingle(
                    Horizon.TransactionResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {

                        case .failure(let error):
                            completion(.failure(error))

                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })

        return cancelable
    }
}

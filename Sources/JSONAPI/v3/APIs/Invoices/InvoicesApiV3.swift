import DLJSONAPI

/// Class provides functionality that allows to fetch invoices data
public class InvoicesApiV3: JSONAPI.BaseApi {

    // MARK: - Public properties

    public let requestBuilder: InvoicesRequestBuilderV3

    // MARK: -

    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = .init(
            builderStack: .fromApiStack(apiStack)
        )

        super.init(apiStack: apiStack)
    }

    // MARK: - Public

    /// Creates invoice.
    /// - Parameters:
    ///   - amount: Requested amount.
    ///   - subject: Subject.
    ///   - requestorAccountId: Requestor's account identifier.
    ///   - targetAccountId: Target's account identifier.
    ///   - assetCode: Asset code.
    ///   - destinationCardNumber: Requestor's card number.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestCreateInvoice(
        amount: String,
        subject: String?,
        requestorAccountId: String,
        targetAccountId: String,
        assetCode: String,
        destinationCardNumber: String,
        completion: @escaping (_ result: RequestEmptyResult) -> Void
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        let request: CreateInvoiceRequest = .init(
            data: .init(
                attributes: .init(
                    amount: amount,
                    subject: subject ?? ""
                ),
                relationships: .init(
                    requestor: .init(
                        data: .init(
                            id: requestorAccountId,
                            type: "accounts"
                        )
                    ),
                    target: .init(
                        data: .init(
                            id: targetAccountId,
                            type: "accounts"
                        )
                    ),
                    asset: .init(
                        data: .init(
                            id: assetCode,
                            type: "assets"
                        )
                    ),
                    destinationCard: .init(
                        data: .init(
                            id: destinationCardNumber,
                            type: "cards"
                        )
                    )
                )
            )
        )

        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }

        self.requestBuilder.buildCreateInvoiceRequest(
            bodyParameters: encodedRequest,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in

                        switch result {

                        case .failure(let error):
                            completion(.failure(error))

                        case .success:
                            completion(.success)
                        }
                })
        })

        return cancelable
    }
}

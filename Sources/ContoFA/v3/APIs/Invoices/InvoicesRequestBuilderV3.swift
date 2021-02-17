import DLJSONAPI

public class InvoicesRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {

    // MARK: - Private properties

    private let integrations: String = "integrations"
    private let invoices: String = "invoices"

    // MARK: - Public

    /// Builds request to create invoice
    public func buildCreateInvoiceRequest(
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.invoices

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

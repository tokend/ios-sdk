import Foundation

public class KYCRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {

    // MARK: - Private properties

    private var integrations: String { "integrations" }
    private var kyc: String { "kyc" }

    // MARK: - Public properties

    public func buildGetKycEntryRequest(
        by accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.kyc/accountId

        self.buildRequest(
            .simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    public func buildPostKYCEntryRequest(
        bodyParameters: [String: Any],
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.kyc

        self.buildRequest(
            .init(
                path: path,
                method: .post,
                bodyParameters: bodyParameters,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

import Foundation

public class FriendsRequestBuilder: JSONAPI.BaseApiRequestBuilder {

    // MARK: - Private properties

    private let integrations: String = "integrations"
    private let friends: String = "friends"
    private let multi: String = "multi"
    private let recentPayments: String = "recent_payments"

    // MARK: - Public

    public func buildFriendsRequest(
        accountId: String,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.friends/accountId

        self.buildRequest(
            .simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: RequestQueryParameters(),
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    public func buildFriendMultipleRequest(
        accountId: String,
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.friends/accountId/self.multi

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

    public func buildRecentPaymentsRequest(
        accountId: String,
        filters: FriendsRequestsFilters,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.friends/accountId/self.recentPayments

        let queryParameters = self.buildFilterQueryItems(filters.filterItems)

        self.buildRequest(
            .simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    public func buildSavePaymentRequest(
        accountId: String,
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.friends/accountId/self.recentPayments

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

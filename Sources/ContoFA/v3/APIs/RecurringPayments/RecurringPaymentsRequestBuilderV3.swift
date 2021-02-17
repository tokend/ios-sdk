import Foundation

public class RecurringPaymentsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {

    // MARK: - Private properties

    private let integrations: String = "integrations"
    private let rpayments: String = "rpayments"
    private let schedule: String = "schedule"
    private let info: String = "info"

    // MARK: - Public

    /// Builds request to fetch system info
    public func buildSystemInfoRequest(
    ) -> JSONAPI.RequestModel {

        let path = /self.integrations/self.rpayments/self.info

        return self.buildRequest(
            .simple(
                path: path,
                method: .get
            )
        )
    }

    /// Builds request to schedule recurring payment
    public func buildSchedulePaymentRequest(
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.rpayments/self.schedule

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

    /// Builds request to fetch recurring payments
    public func buildScheduledPaymentsRequest(
        filters: RecurringPaymentsRequestsFilters,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.rpayments/self.schedule

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

    /// Builds request to fetch recurring payment
    public func buildScheduledPaymentRequest(
        id: String,
        include: [String]?,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.rpayments/self.schedule/id

        self.buildRequest(
            .simpleQueryInclude(
                path: path,
                method: .get,
                queryParameters: RequestQueryParameters(),
                include: include
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    /// Builds request to delete recurring payment
    public func buildDeleteScheduledPaymentRequest(
        id: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.rpayments/self.schedule/id

        self.buildRequest(
            .init(
                path: path,
                method: .delete
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

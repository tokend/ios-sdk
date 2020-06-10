import Foundation

public class CardsRequestBuilder: JSONAPI.BaseApiRequestBuilder {

    public typealias CardNumber = String

    // MARK: - Private properties

    private let integrations: String = "integrations"
    private let cards: String = "cards"

    // MARK: - Public properties

    // MARK: - Public

    /// Builds request to fetch cards
    public func buildCardsRequest(
        filters: CardsRequestsFilters,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.cards

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

    /// Builds request to fetch reviewable card
    public func buildCardRequest(
        cardNumber: CardNumber,
        include: [String]?,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.cards/"\(cardNumber)"

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
}

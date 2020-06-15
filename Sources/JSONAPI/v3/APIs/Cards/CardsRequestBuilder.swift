import Foundation

public class CardsRequestBuilder: JSONAPI.BaseApiRequestBuilder {

    public typealias CardNumber = String

    // MARK: - Private properties

    private let integrations: String = "integrations"
    private let cards: String = "cards"
    private let publicCards: String = "public"

    // MARK: - Public properties

    // MARK: - Public

    /// Builds request to create card
    public func buildCreateCardRequest(
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.cards

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

    /// Builds request to fetch public cards
    public func buildPublicCardsRequest(
        bodyParameters: [String: Any],
        include: [String]?
    ) -> JSONAPI.RequestModel {

        let path = /self.integrations/self.cards/self.publicCards

        return self.buildRequest(
            .init(
                path: path,
                method: .post,
                bodyParameters: bodyParameters,
                include: include
            )
        )
    }
}

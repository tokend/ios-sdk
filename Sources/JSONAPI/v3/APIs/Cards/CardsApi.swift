import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch cards data
public class CardsApi: JSONAPI.BaseApi {

    public typealias CardNumber = String

    // MARK: - Public properties

    public let requestBuilder: CardsRequestBuilder

    // MARK: - 

    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = .init(
            builderStack: .fromApiStack(apiStack)
        )

        super.init(apiStack: apiStack)
    }

    // MARK: - Public

    /// Creates card for given account.
    /// - Parameters:
    ///   - cardNumber: Number of the card to create.
    ///   - accountId: Account id create card for.
    ///   - balanceIds: Balance ids for the card.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestAddCard(
        cardNumber: CardNumber,
        name: String,
        isPhysical: Bool,
        expirationYear: Int,
        expirationMonth: Int,
        designName: String,
        accountId: String,
        balanceIds: [String],
        completion: @escaping (_ result: RequestEmptyResult) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        let request: AddCardRequest = .init(
            data: .init(
                attributes: .init(
                    cardNumber: cardNumber,
                    details: .init(
                        name: name,
                        isPhysical: isPhysical,
                        expirationYear: expirationYear,
                        expirationMonth: expirationMonth,
                        design: designName,
                        isActivated: true
                    )
                ),
                relationships: .init(
                    owner: .init(
                        data: .init(
                            id: accountId
                        )
                    ),
                    balances: .init(
                        data: balanceIds.map { .init(id: $0) }
                        ),
                    securityDetails: .init(
                        data: .init()
                    )
                )
            ),
            included: [
                .init(
                    relationships: .init(
                        card: .init(
                            data: .init(
                                id: cardNumber
                            )
                        )
                    )
                )
            ]
        )

        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }

        self.requestBuilder.buildCreateCardRequest(
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

    /// Returns the list of cards.
    /// If filter by owner (filter[owner]) is provided, the owner's signature is also valid.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<Cards.CardBalanceResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestCards(
        filters: CardsRequestsFilters,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping (_ result: RequestCollectionResult<Cards.CardResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildCardsRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    Cards.CardResource.self,
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

    /// Returns the specified card.
    /// - Parameters:
    ///   - cardNumber: Number of card to fetch.
    ///   - include: Resource of include.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<Cards.CardBalanceResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestCard(
        cardNumber: CardNumber,
        include: [String]?,
        completion: @escaping (_ result: RequestSingleResult<Cards.CardResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildCardRequest(
            cardNumber: cardNumber,
            include: include) { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestSingle(
                    Cards.CardResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {

                        case .failure(let error):
                            completion(.failure(error))

                        case .success(let document):
                            completion(.success(document))
                        }
                })
        }

        return cancelable
    }

    /// Returns public cards for account ids.
    /// - Parameters:
    ///   - accountIds: Account ids to request cards for.
    ///   - include: Resource of include.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<Cards.CardResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestPublicCards(
        accountIds: [String],
        include: [String]?,
        completion: @escaping (_ result: RequestCollectionResult<Cards.CardResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        let body: PublicCardListTempView = .init(
            data: .init(
                relationships: .init(
                    owners: .init(
                        data: accountIds.map { .init(id: $0) }
                    )
                )
            )
        )

        guard let encodedBody = try? body.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }

        let request = self.requestBuilder.buildPublicCardsRequest(
            bodyParameters: encodedBody,
            include: include
        )

        cancelable.cancelable = self.requestCollection(
            Cards.CardResource.self,
            request: request,
            completion: completion
        )

        return cancelable
    }

    /// Model that will be fetched in `completion` block of ` CardsApi.requestUpdateCard(...)`
    public enum RequestCardUpdateResult {

        /// Errors that are possible to be fetched.
        public enum RequestError: Swift.Error, LocalizedError {

            /// Balance from bind_balances already exists for this card
            case balanceAlreadyExists

            case other(Error)

            // MARK: - Swift.Error

            public var errorDescription: String? {
                switch self {

                case .balanceAlreadyExists:
                    return "Balance already exists for this card"

                case .other(let error):
                    return error.localizedDescription
                }
            }
        }

        case success

        case failure(RequestError)
    }
    /// Allows to update card info.
    /// - Parameters:
    ///   - cardNumber: Number of card to fetch.
    ///   - bindBalanceIds: Balances to bind to the card.
    ///   - unbindBalanceIds: Balances to unbind from the card.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCardUpdateResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestUpdateCard(
        by cardNumber: CardNumber,
        bindBalanceIds: [String],
        unbindBalanceIds: [String],
        completion: @escaping (_ result: RequestCardUpdateResult) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        let body: UpdateCardRequest = .init(
            data: .init(
                attributes: .init(),
                relationships: .init(
                    bindBalances: .init(
                        data: bindBalanceIds.map { (balance) in
                            .init(
                                id: balance
                            )
                        }
                    ),
                    unbindBalances: .init(
                        data: unbindBalanceIds.map { (balance) in
                            .init(
                                id: balance
                            )
                        }
                    )
                )
            )
        )

        guard let encodedBody = try? body.documentDictionary() else {
            completion(.failure(.other(JSONAPIError.failedToBuildRequest)))
            return cancelable
        }

        self.requestBuilder.buildUpdateCardRequest(
            by: cardNumber,
            bodyParameters: encodedBody,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(.other(JSONAPIError.failedToSignRequest)))
                    return
                }

                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in
                        switch result {

                        case .failure(let error):
                            if error.contains(status: "409") {
                                completion(.failure(.balanceAlreadyExists))
                            } else {
                                completion(.failure(.other(error)))
                            }

                        case .success:
                            completion(.success)
                        }
                })
        })

        return cancelable
    }
}

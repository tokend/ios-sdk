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
        completion: @escaping (_ result: RequestCollectionResult<Cards.CardBalanceResource>) -> Void
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
                    Cards.CardBalanceResource.self,
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
}

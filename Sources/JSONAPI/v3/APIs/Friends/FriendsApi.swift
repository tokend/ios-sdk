import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch friends data
public class FriendsApi: JSONAPI.BaseApi {

    // MARK: - Public properties

    public let requestBuilder: FriendsRequestBuilder

    // MARK: -

    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = .init(
            builderStack: .fromApiStack(apiStack)
        )

        super.init(apiStack: apiStack)
    }

    // MARK: - Public

    /// Returns the list of friends.
    /// - Parameters:
    ///   - accountId: Account id for which request will be fetched.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<Friends.UserResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestFriends(
        accountId: String,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping (_ result: RequestCollectionResult<Friends.UserResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildFriendsRequest(
            accountId: accountId,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    Friends.UserResource.self,
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

    /// Adds friends with phone numbers.
    /// - Parameters:
    ///   - accountId: Account id for which friends should be added.
    ///   - phones: Phone numbers of friends.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestFriends(
        accountId: String,
        phones: [String],
        completion: @escaping (_ result: RequestEmptyResult) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        let data: [FriendMultipleRequest.Data.Relationships.NewFriends.NewFriend] = phones
            .map { (phone) in
                .init(
                    id: phone
                )
        }
        let request: FriendMultipleRequest = .init(
            data: .init(
                relationships: .init(
                    newFriends: .init(
                        data: data
                    )
                )
            )
        )

        guard let dictionary = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }

        self.requestBuilder.buildFriendMultipleRequest(
            accountId: accountId,
            bodyParameters: dictionary,
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

    /// Returns the list of recent payments.
    /// - Parameters:
    ///   - accountId: Account id for which request will be fetched.
    ///   - filters: Request filters.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<Friends.RecentPaymentResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestRecentPayments(
        accountId: String,
        filters: FriendsRequestsFilters,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping (_ result: RequestCollectionResult<Friends.RecentPaymentResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildRecentPaymentsRequest(
            accountId: accountId,
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    Friends.RecentPaymentResource.self,
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

    /// Saves payment.
    /// - Parameters:
    ///   - accountId: Account id for which request will be fetched.
    ///   - createdAt: Timestamp the payment was created at.
    ///   - sourceAccountId: Payment source account id.
    ///   - destinationAccountId: Payment destination account id.
    ///   - destinationCard: Payment destination card number.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestSavePayment(
        accountId: String,
        createdAt: TimeInterval,
        sourceAccountId: String,
        destinationAccountId: String,
        destinationCard: String,
        completion: @escaping (_ result: RequestEmptyResult) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        let request: RecordPaymentRequest = .init(
            data: .init(
                attributes: .init(
                    createdAt: createdAt
                ),
                relationships: .init(
                    source: .init(
                        data: .init(
                            id: sourceAccountId
                        )
                    ),
                    destination: .init(
                        data: .init(
                            id: destinationAccountId
                        )
                    ),
                    destinationCard: .init(
                        data: .init(
                            id: destinationCard
                        )
                    )
                )
            )
        )

        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }

        self.requestBuilder.buildSavePaymentRequest(
            accountId: accountId,
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

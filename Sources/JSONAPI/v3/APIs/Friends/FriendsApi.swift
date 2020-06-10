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

    @discardableResult
    public func requestFriends(
        accountId: String,
        phones: [String]
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

        guard let encodedRequest = try? request.documentDictionary() else {
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

    @discardableResult
    func requestRecentPayments(
        accountId: String,
        filters: FriendsRequestsFilters,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping (_ result: RequestCollectionResult<Friends.RecentPaymentResource>) -> Void
    ) {

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

    @discardableResult
    func requestSavePayment(
        accountId: String,
        createdAt: TimeInterval,
        sourceAccountId: String,
        destinationAccountId: String,
        destinationCard: String,
        completion: @escaping (_ result: RequestEmptyResult) -> Void
    ) {

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

        guard let body = try? recordPaymentResource.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }

        self.requestBuilder.buildSavePaymentRequest(
            accountId: accountId,
            bodyParameters: body,
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

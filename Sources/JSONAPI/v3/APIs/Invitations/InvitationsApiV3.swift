import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch invitations' data
public class InvitationsApiV3: JSONAPI.BaseApi {

    // MARK: - Public properties

    public let requestBuilder: InvitationsRequestBuilderV3

    // MARK: -

    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = InvitationsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )

        super.init(apiStack: apiStack)
    }

    // MARK: - Public

    /// Method sends request to fetch invitations from api.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestCollectionResult<InvitationsResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getInvitations(
        filters: InvitationsRequestFiltersV3,
        sort: InvitationsRequestBuilderV3.SortedInvitationsRequestSort,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<InvitationsResource>) -> Void)
        ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildSortedInvitationsRequest(
            filters: filters,
            sort: sort,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    InvitationsResource.self,
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

    /// Method sends request to accept invitation.
    /// - Parameters:
    ///   - id: The invitation id.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    public func acceptInvitation(
        id: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildAcceptInvitationRequest(
            id: id,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in

                        switch result {

                        case .success:
                            completion(.success)

                        case .failure(let error):
                            completion(.failure(error))
                        }
                })
        })

        return cancelable
    }

    /// Method sends request to cancel invitation.
    /// - Parameters:
    ///   - id: The invitation id.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    public func cancelInvitation(
        id: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildCancelInvitationRequest(
            id: id,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in

                        switch result {

                        case .success:
                            completion(.success)

                        case .failure(let error):
                            completion(.failure(error))
                        }
                })
        })

        return cancelable
    }

    /// Method sends request to wait invitation.
    /// - Parameters:
    ///   - id: The invitation id.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    public func waitInvitation(
        id: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildWaitInvitationRequest(
            id: id,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in

                        switch result {

                        case .success:
                            completion(.success)

                        case .failure(let error):
                            completion(.failure(error))
                        }
                })
        })

        return cancelable
    }

    public enum GetSignedInvitationRedeemAuthResult {
        case success(auth: String)
        case failure(Error)
    }
    /// Method builds signed header auth value for invitation redeem request.
    /// - Parameters:
    ///   - id: Invitation identifier.
    ///   - completion: The block which is called when the result is ready.
    ///   - result: The model of `GetSignedInvitationRedeemAuthResult`
    public func getSignedInvitationRedeemAuth(
        for id: String,
        completion: @escaping ((_ result: GetSignedInvitationRedeemAuthResult) -> Void)
    ) {

        self.requestBuilder.buildSignedInvitationRedeemAuthRequest(
            id: id,
            completion: { (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                guard let authHeader = request.headers?["Authorization"]
                    else {
                        completion(.failure(JSONAPIError.failedToSignRequest))
                        return
                }

                completion(.success(auth: authHeader))
        })
    }
}

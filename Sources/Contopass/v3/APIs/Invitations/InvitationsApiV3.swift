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
    public func getSortedInvitations(
        filters: InvitationsRequestFiltersV3,
        sort: InvitationsRequestBuilderV3.SortedInvitationsRequestSort,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<Invitations.InvitationResource>) -> Void)
        ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

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
                    Invitations.InvitationResource.self,
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
    
    /// Method sends request to create a new invitation
    /// - Parameters:
    ///     - hostId: Host user accountId
    ///     - guestId: Guest user accountId
    ///     - placeId: Place asset identifier
    ///     - from: Date when pass becomes active
    ///     - to: Date when pass stops being active
    ///     - addressDetails: Note which gives extra explanation for both guest and host about their meeting place
    ///     - personalNote: Note which is seen only for host user
    ///     - completion: The block which is called when the result will be fetched
    ///     - result: The model of `RequestSingleResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func createInvitation(
        hostId: String,
        guestId: String,
        placeId: String,
        from: Date,
        to: Date,
        addressDetails: String?,
        personalNote: String?,
        completion: @escaping ((_ result: RequestSingleResult<Invitations.InvitationResource>) -> Void)
    ) -> Cancelable {
        
        let dateFormatter = DateFormatters.iso8601DateFormatter
        
        let cancelable = self.network.getEmptyCancelable()
        
        let request: CreateInvitationRequest = .init(
            data: .init(
                attributes: .init(
                    details: .init(
                        addressDetails: addressDetails,
                        personalNote: personalNote
                    ),
                    from: dateFormatter.string(from: from),
                    to: dateFormatter.string(from: to)
                ),
                relationships: .init(
                    host: .init(
                        data: .init(id: hostId)
                    ),
                    guest: .init(
                        data: .init(id: guestId)
                    ),
                    place: .init(
                        data: .init(id: placeId)
                    )
                )
            )
        )
        
        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }
        
        self.requestBuilder.buildCreateInvitationRequest(
            bodyParameters: encodedRequest,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    Invitations.InvitationResource.self,
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .success(let document):
                            completion(.success(document))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
            })
        
        return cancelable
    }

    /// Method sends request to accept invitation.
    /// - Parameters:
    ///   - id: The invitation id.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func acceptInvitation(
        id: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

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
    @discardableResult
    public func cancelInvitation(
        id: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

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

    /// Method sends request to delete invitation.
    /// - Parameters:
    ///   - id: The invitation id.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func deleteInvitation(
        id: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildDeleteInvitationRequest(
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
    @discardableResult
    public func waitInvitation(
        id: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

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

    /// Method sends request to fetch invitations history from api.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestCollectionResult<InvitationsHistoryResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getInvitationsHistory(
        filters: InvitationsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<Invitations.EventResource>) -> Void)
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildInvitationsHistoryRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    Invitations.EventResource.self,
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
    
    /// Method requests system info
    /// - Parameters:
    ///   - completion: The block which is called when the result is ready.
    ///   - result: The model of `SystemInfoResource`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getSystemInfo(
        completion: @escaping (Result<Document<SystemInfoResource>, Error>) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildSystemInfoRequest(
            completion: { (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self.requestSingle(
                    SystemInfoResource.self,
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .success(let data):
                            completion(.success(data))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }

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
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<Invitations.InvitationResource>) -> Void)
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildInvitationsRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    Invitations.InvitationResource.self,
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
}

import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch invitations' data
public class InvitationsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {

    // MARK: - Public properties

    private var integrations: String { "integrations" }
    private var invitations: String { "invitations" }
    private var info: String { "info" }
    private var sorted: String { "sorted" }
    private var sortKey: String { "sort" }
    private var redeem: String { "redeem" }
    private var accept: String { "accept" }
    private var cancel: String { "cancel" }
    private var wait: String { "wait" }
    private var history: String { "history" }
    private static var sortFromValue: String { "from" }
    private static var sortUpdatedAtValue: String { "updated_at" }

    // MARK: - Public

    public enum SortedInvitationsRequestSort {

        case from(descending: Bool)
        case updatedAt(descending: Bool)

        var value: String {
            switch self {

            case .from(let descending):
                return descending ? ["-", sortFromValue].joined() : sortFromValue

            case .updatedAt(let descending):
                return descending ? ["-", sortUpdatedAtValue].joined() : sortUpdatedAtValue
            }
        }
    }
    
    /// Builds request to create new invitation
    public func buildCreateInvitationRequest(
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.integrations/self.invitations
        
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

    /// Builds request to fetch sorted invitations.
    /// - Parameters:
    ///   - saleId: Id of sale to be fetched.
    /// - Returns: `RequestModel`.
    public func buildSortedInvitationsRequest(
        filters: InvitationsRequestFiltersV3,
        sort: SortedInvitationsRequestSort,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {

        let path = /self.integrations/self.invitations/self.sorted
        var queryParameters = self.buildFilterQueryItems(filters.filterItems)
        queryParameters["sort"] = sort.value

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

    /// Builds request to accept invitation.
    /// - Parameters:
    ///   - id: The invitation id.
    public func buildAcceptInvitationRequest(
        id: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.invitations/id/self.accept

        self.buildRequest(
            .simple(
                path: path,
                method: .patch
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    /// Builds request to cancel invitation.
    /// - Parameters:
    ///   - id: The invitation id.
    public func buildCancelInvitationRequest(
        id: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.invitations/id/self.cancel

        self.buildRequest(
            .simple(
                path: path,
                method: .patch
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    /// Builds request to delete invitation.
    /// - Parameters:
    ///   - id: The invitation id.
    public func buildDeleteInvitationRequest(
        id: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.invitations/id

        self.buildRequest(
            .simple(
                path: path,
                method: .delete
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    /// Builds request to wait invitation.
    /// - Parameters:
    ///   - id: The invitation id.
    public func buildWaitInvitationRequest(
        id: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.invitations/id/self.wait

        self.buildRequest(
            .simple(
                path: path,
                method: .patch
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    public func buildSignedInvitationRedeemAuthRequest(
        id: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.invitations/id/self.redeem

        self.buildRequest(
            .simple(
                path: path,
                method: .patch
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    public func buildInvitationsHistoryRequest(
        filters: InvitationsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = /self.integrations/self.invitations/self.history
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
    
    public func buildSystemInfoRequest(
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = /self.integrations/self.invitations/self.info
        
        self.buildRequest(
            .simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }

    public func buildInvitationsRequest(
        filters: InvitationsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {

        let path = /self.integrations/self.invitations
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
}

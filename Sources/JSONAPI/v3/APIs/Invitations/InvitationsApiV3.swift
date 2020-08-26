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
}

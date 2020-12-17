import Foundation
import DLJSONAPI

public class KYCApiV3: JSONAPI.BaseApi {

    // MARK: - Public properties

    public let requestBuilder: KYCRequestBuilderV3

    // MARK: -

    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = .init(
            builderStack: .fromApiStack(apiStack)
        )

        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public methods

    // Used to request single user
    @discardableResult
    public func getKycEntry(
        by accountId: String,
        completion: @escaping (RequestSingleResult<KYC.KycResource>) -> Void
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildGetKycEntryRequest(
            by: accountId,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestSingle(
                    KYC.KycResource.self,
                    request: request,
                    completion: { (result) in

                        switch result {

                        case .failure(let error):
                            completion(.failure(error))

                        case .success(let document):
                            completion(.success(document))
                        }
                    }
                )
            }
        )

        return cancelable
    }

    // Used to request many users
    @discardableResult
    public func postKycEntries(
        accountIds: [String],
        pagination: RequestPagination,
        completion: @escaping (RequestCollectionResult<KYC.KycResource>) -> Void
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        let request: PostKYCEntriesRequest = .init(
            data: .init(
                relationships: .init(
                    accounts: .init(
                        data: accountIds.map {
                            PostKYCEntriesRequest.Data.Relationships.Accounts.Data(
                                id: $0
                            )
                        }
                    )
                )
            )
        )

        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }

        self.requestBuilder.buildPostKYCEntryRequest(
            bodyParameters: encodedRequest,
            pagination: pagination,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    KYC.KycResource.self,
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
        )

        return cancelable
    }
}

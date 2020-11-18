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

    @discardableResult
    public func getKycEntry(
        by accountId: String,
        completion: @escaping (RequestSingleResult<KYC.KycResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildKycEntryRequest(
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
}

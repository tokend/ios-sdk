import Foundation
import DLJSONAPI

public class SaleCloserApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: SaleCloserRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = SaleCloserRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    /// Returns info.
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<SaleCloser.LPProviderSignerResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestLPSigner(
        completion: @escaping (_ result: RequestSingleResult<SaleCloser.LPProviderSignerResource>) -> Void
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildLPSignerRequest(
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestSingle(
                    SaleCloser.LPProviderSignerResource.self,
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

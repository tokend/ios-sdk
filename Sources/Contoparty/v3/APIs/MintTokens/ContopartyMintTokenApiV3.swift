import Foundation
import DLJSONAPI

public extension Contoparty {
    
    class MintTokenApiV3: JSONAPI.BaseApi {
        
        // MARK: - Public properties
        
        public let requestBuilder: MintTokenRequestBuilderV3
        
        // MARK: -
        
        public required init(apiStack: JSONAPI.BaseApiStack) {
            self.requestBuilder = .init(
                builderStack: .fromApiStack(apiStack)
            )
            
            super.init(apiStack: apiStack)
        }
    }
}

// MARK: - Public methods

public extension Contoparty.MintTokenApiV3 {
    
    @discardableResult
    func mintToken(
        parameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildMintTokenRequest(
            bodyParameters: parameters,
            sendDate: sendDate,
            completion: { [weak self] request in
                
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
                    }
                )
            }
        )
        
        return cancelable
    }
}

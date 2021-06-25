import Foundation
import DLJSONAPI

public extension Contoparty {
    
    class TokensApiV3: JSONAPI.BaseApi {
        
        // MARK: - Public properties
        
        public let requestBuilder: TokensRequestBuilderV3
        
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

public extension Contoparty.TokensApiV3 {
    
    @discardableResult
    func getListOfTokens(
        filters: Contoparty.TokensRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<Contoparty.TokenResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetListOfTokens(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    Contoparty.TokenResource.self,
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
    
    @discardableResult
    func getITokensHistory(
        filters: Contoparty.TokensRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<Contoparty.TokenHistoryResource>) -> Void)
    ) -> Cancelable {

        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildTokensHistoryRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    Contoparty.TokenHistoryResource.self,
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

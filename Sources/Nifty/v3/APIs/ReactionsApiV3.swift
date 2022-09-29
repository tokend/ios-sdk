import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch and change reactions
public class ReactionsApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: ReactionsRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = ReactionsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    @discardableResult
    public func createReaction(
        titleId: String,
        reactionType: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
            
            let request: CreateReactionRequest = .init(
                titleId: titleId,
                reactionType: reactionType
            )
            
            guard let encodedRequest = try? request.documentDictionary() else {
                completion(.failure(JSONAPIError.failedToBuildRequest))
                return cancelable
            }
            
        self.requestBuilder.buildCreateReactionRequest(
            bodyParameters: encodedRequest,
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
                    }
                )
            }
        )
        
        return cancelable
    }
    
    @discardableResult
    public func deleteReaction(
        titleId: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildDeleteReactionRequest(
            titleId: titleId,
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
                    }
                )
            }
        )
        
        return cancelable
    }
    
    @discardableResult
    public func getReactionsList(
        filters: ReactionsRequestFiltersV3,
        completion: @escaping ((_ result: RequestCollectionResult<Nifty.ReactionResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetReactionsListRequest(
            filters: filters,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    Nifty.ReactionResource.self,
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
    public func getSalesList(
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<Horizon.SaleResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetSalesListRequest(
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    Horizon.SaleResource.self,
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

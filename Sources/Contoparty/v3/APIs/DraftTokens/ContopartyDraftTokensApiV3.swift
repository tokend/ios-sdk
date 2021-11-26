import Foundation
import DLJSONAPI

public extension Contoparty {
    
    class DraftTokensApiV3: JSONAPI.BaseApi {
        
        // MARK: - Public properties
        
        public let requestBuilder: DraftTokensRequestBuilderV3
        
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

public extension Contoparty.DraftTokensApiV3 {
    
    @discardableResult
    func getListOfDraftTokens(
        filters: Contoparty.DraftTokensRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<Contoparty.DraftTokenResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetListOfDraftTokens(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    Contoparty.DraftTokenResource.self,
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
    func getDraftTokenById(
        id: String,
        completion: @escaping ((_ result: RequestSingleResult<Contoparty.DraftTokenResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetDraftTokenById(
            id: id,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    Contoparty.DraftTokenResource.self,
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
    func updateTokenDetails(
        id: String,
        details: [String: Any],
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let bodyParameters: [String: Any] = ["details": details]
        
        self.requestBuilder.buildUpdateTokenDetails(
            id: id,
            bodyParameters: bodyParameters,
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
    func deleteDraftToken(
        id: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildDeleteDraftTokenRequest(
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
    
    @discardableResult
    func createDraftToken(
        assetCode: String,
        creator: String,
        logo: String,
        name: String,
        image: String,
        medium: String,
        logoUrl: String,
        isDraft: String,
        dimensions: String,
        logoDraft: BlobResponse.BlobContent.Attachment,
        mediaSize: String,
        description: String,
        mediaDraft: BlobResponse.BlobContent.Attachment,
        collaborators: String,
        dateOrSeason: String,
        representation: String,
        directionsForUse: String,
        unlockableContent: String,
        tokenTypeName: String,
        tokenTypeValue: Int32,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {
                
        let cancelable = self.network.getEmptyCancelable()
        
        let request: CreateDraftRequest = .init(
            data: .init(
                type: Contoparty.CreateDraftTokenResource.resourceType,
                attributes: .init(
                    assetCode: assetCode,
                    creator: creator,
                    details: .init(
                        logo: logo,
                        name: name,
                        image: image,
                        medium: medium,
                        logoUrl: logoUrl,
                        isDraft: isDraft,
                        dimensions: dimensions,
                        logoDraft: logoDraft,
                        mediaSize: mediaSize,
                        description: description,
                        mediaDraft: mediaDraft,
                        collaborators: collaborators,
                        dateOrSeason: dateOrSeason,
                        representation: representation,
                        directionsForUse: directionsForUse,
                        unlockableContent: unlockableContent
                    ),
                    type: .init(
                        name: tokenTypeName,
                        value: tokenTypeValue
                    )
                )
            )
        )
        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }
        
        self.requestBuilder.buildCreateDraftTokenRequest(
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
                            
                        case .success:
                            completion(.success)
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    })
            })
        
        return cancelable
    }
}

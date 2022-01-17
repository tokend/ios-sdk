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
        id: String,
        ipfsUrl: String,
        assetCode: String,
        details: MintTokenRequest.Attributes.Details,
        senderAccountId: String,
        amount: Int64,
        mintTarget: MintTokenRequest.Attributes.ObjectType,
        tokenType: MintTokenRequest.Attributes.ObjectType,
        isEdition: Bool,
        completion: @escaping ((_ result: RequestSingleResult<Contoparty.ContopartyMintTokenResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let relationships: MintTokenRequest.Relationships
        let included: [MintTokenRequest.Included]?
        if isEdition {
            relationships = .init(
                edition: .init(
                    data: .init(id: details.name)
                ),
                draftToDelete: .init(
                    data: .init(id: id)
                )
            )
            included = [
                .init(
                    id: details.name,
                    attributes: .init(name: details.name)
                )
            ]
        } else {
            relationships = .init(
                edition: nil,
                draftToDelete: .init(
                    data: .init(id: id)
                )
            )
            included = nil
        }
        let request: MintTokenRequest = .init(
            data: .init(
                type: Contoparty.MintV2Resource.resourceType,
                attributes: .init(
                    ipfsUrl: ipfsUrl,
                    assetCode: assetCode,
                    details: details,
                    senderAccountId: senderAccountId,
                    amount: amount,
                    mintTarget: mintTarget,
                    tokenType: tokenType
                ),
                relationships: relationships
            ),
            included: included
        )
        
        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }
        
        self.requestBuilder.buildMintTokenRequest(
            bodyParameters: encodedRequest,
            completion: { [weak self] request in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    Contoparty.ContopartyMintTokenResource.self,
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

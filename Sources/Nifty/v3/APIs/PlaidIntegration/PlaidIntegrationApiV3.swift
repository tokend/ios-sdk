import Foundation
import DLJSONAPI

public class PlaidIntegrationApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: PlaidIntegrationRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = PlaidIntegrationRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public

    
    @discardableResult
    public func initKyc(
        accountId: String,
        email: String,
        completion: @escaping ((_ result: RequestSingleResult<PlaidIntegration.LinkTokenResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let request: InitPlaidKycRequest = .init(
            data: .init(
                attributes: .init(
                    account_id: accountId, email: email
                )
            )
        )
        
        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }
        
        self.requestBuilder.buildInitKycRequest(
            bodyParameters: encodedRequest
        ) { [weak self] (request) in
            
            guard let request = request else {
                completion(.failure(JSONAPIError.failedToBuildRequest))
                return
            }
            
            cancelable.cancelable = self?.requestSingle(
                PlaidIntegration.LinkTokenResource.self,
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
        return cancelable
    }
     
    
    @discardableResult
    public func getKycStatus(
        accountId: String,
        completion: @escaping ((_ result: RequestSingleResult<PlaidIntegration.KYCStatusResource>) -> Void)
    ) -> Cancelable {
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetKycStatusRequest(
            accountId: accountId
        ) { [weak self] (request) in
            guard let request = request else {
                completion(.failure(JSONAPIError.failedToSignRequest))
                return
            }
            
            cancelable.cancelable = self?.requestSingle(
                PlaidIntegration.KYCStatusResource.self,
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
        return cancelable
    }
                
    @discardableResult
    public func getListKycStatuses(
        filters: PlaidIntegrationRequestFiletersV3,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<PlaidIntegration.KYCStatusResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetListKycStatuses(
            filters: filters,
            pagination: pagination
        ) { [weak self] (request) in
            
            guard let request = request else {
                completion(.failure(JSONAPIError.failedToBuildRequest))
                return
            }
            
            cancelable.cancelable = self?.requestCollection(
                PlaidIntegration.KYCStatusResource.self,
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
        return cancelable
    }
}

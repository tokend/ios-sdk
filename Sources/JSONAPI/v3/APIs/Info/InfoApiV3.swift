import Foundation
import DLJSONAPI

public class InfoApiV3: JSONAPI.BaseApi {
    
    public let requestBuilder: InfoRequestBuilderV3
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = .init(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
}

// MARK: Public methods

public extension InfoApiV3 {
    
    /// Allows getting basic info about horizon state and it's dependencies
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///     - result: Member of `RequestSingleResult<Horizon.HorizonStateResource>`
    /// - Returns: `Cancelable`
    enum RequestInfoError: Swift.Error {
        
        case cannotDecode
    }
    @discardableResult
    func requestInfo(
        completion: @escaping (_ result: Swift.Result<NetworkInfoModel, Swift.Error>) -> Void
    ) -> Cancelable {
        
        let request = self.requestBuilder.buildInfoRequest()
        
        let requestTime = Date()
        let cancelable = self.requestSingle(
            Horizon.HorizonStateResource.self,
            request: request,
            completion: { (result) in
                
                let responseTime = Date()
                switch result {
                
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let document):
                    if let data = document.data,
                       let info = NetworkInfoModel(
                        networkInfoResponse: data,
                        requestTime: requestTime,
                        responseTime: responseTime
                       ) {
                        
                        completion(.success(info))
                    } else {
                        completion(.failure(RequestInfoError.cannotDecode))
                    }
                }
            }
        )
        
        return cancelable
    }
}

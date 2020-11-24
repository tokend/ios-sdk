import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch hospital data
public class HospitalsApiV3: JSONAPI.BaseApi {
    
    public let requestBuilder: HospitalsRequestBuilderV3
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = HospitalsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public

    @discardableResult
    public func requestHospital(
        hospitalId: String,
        completion: @escaping (_ result: RequestSingleResult<MunaTestResults.AlphaResource>) -> Void
        ) -> Cancelable {
        
        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildHospitalRequest(
            hospitalId: hospitalId,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    MunaTestResults.AlphaResource.self,
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

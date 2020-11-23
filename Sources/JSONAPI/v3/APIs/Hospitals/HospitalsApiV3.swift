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
        include: [String]?,
        pagination: RequestPagination?,
        completion: @escaping (_ result: RequestSingleResult<MunaTestResults.AlphaResource>) -> Void
        ) -> Cancelable {
                
        let request = self.requestBuilder.buildHospitalRequest(
            hospitalId: hospitalId
        )
        
        let cancelable = self.requestSingle(
            MunaTestResults.AlphaResource.self,
            request: request,
            completion: completion
        )
        
        return cancelable
    }
}

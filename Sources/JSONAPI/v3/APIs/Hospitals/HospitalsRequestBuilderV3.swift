import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch hospitals' data
public class HospitalsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    private var integrations: String { "integrations" }
    private var testResults: String { "test-results" }
    private var testTypes: String { "test-types" }
    private var accounts: String { "accounts" }
    private var personalData: String { "personal-data" }
    
    public func buildHospitalRequest(
        hospitalId: String
    ) -> JSONAPI.RequestModel {
        
        let path = /self.integrations/self.testResults/self.accounts/hospitalId/self.personalData
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            )
        )
    }
}

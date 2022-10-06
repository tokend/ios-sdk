import Foundation

public class InfoRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Private properties
    
    private let info: String = "info"
    
}

// MARK: - Public methods

public extension InfoRequestBuilderV3 {
    
    func buildInfoRequest(
    ) -> JSONAPI.RequestModel {
        
        let path = self.v3/self.info
        
        return self.buildRequest(
            .simple(
                path: path,
                method: .get
            )
        )
    }
}

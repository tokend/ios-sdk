import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch key-value entries
public class KeyValuesRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let keyValues = "key_values"
    
    // MARK: - Public
    
    /// Builds request to fetch key-value entries from api
    /// - Parameters:
    ///   - pagination: Pagination option.
    /// - Returns: `RequestModelV2`.
    public func buildKeyValueEntriesRequest(
        pagination: RequestPagination
        ) -> JSONAPI.RequestModel {
        
        let path = /self.v3/self.keyValues
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simplePagination(
                path: path,
                method: .get,
                pagination: pagination
            )
        )
    }
    
    /// Builds request to fetch key-value entry by Id
    /// - Parameters:
    ///   - key: Unique identifier of the key-value entry.
    /// - Returns: `RequestModelV2`.
    public func buildKeyValueRequest(
        key: String
        ) -> JSONAPI.RequestModel {
        
        let path = /self.v3/self.keyValues/key
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            )
        )
    }
}

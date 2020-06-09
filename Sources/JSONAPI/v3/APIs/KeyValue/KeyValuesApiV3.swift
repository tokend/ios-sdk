import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch key-value entries
public class KeyValuesApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: KeyValuesRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = KeyValuesRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to get key-value entries from api.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///     - result: Member of `RequestCollectionResult<KeyValueEntryResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestKeyValueEntries(
        pagination: RequestPagination,
        completion: @escaping (_ result: RequestCollectionResult<Horizon.KeyValueEntryResource>) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildKeyValueEntriesRequest(pagination: pagination)
        
        let cancelable = self.requestCollection(
            Horizon.KeyValueEntryResource.self,
            request: request,
            completion: completion
        )
        
        return cancelable
    }
    
    /// Method sends request to get key-value entry by Id.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - key: Unique identifier of the key-value entry.
    ///   - completion: Block that will be called when the result will be received.
    ///     - result: Member of `RequestSingleResult<KeyValueEntryResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestKeyValue(
        key: String,
        completion: @escaping (_ result: RequestSingleResult<Horizon.KeyValueEntryResource>) -> Void
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildKeyValueRequest(key: key)
        
        let cancelable = self.requestSingle(
            Horizon.KeyValueEntryResource.self,
            request: request,
            completion: completion
        )
        
        return cancelable
    }
}

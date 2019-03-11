import Foundation

public struct ApiDataRequest
<DataType: Encodable, IncludeType: Encodable>: Encodable {
    
    // MARK: - Public properties
    
    public let data: DataType
    public let included: [IncludeType]?
    
    // MARK: -
    
    public init(
        data: DataType,
        included: [IncludeType]? = nil
        ) {
        
        self.data = data
        self.included = included
    }
}

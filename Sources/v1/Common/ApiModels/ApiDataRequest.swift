import Foundation

public struct ApiDataRequest<T: Encodable, U: Encodable>: Encodable {
    
    public let data: T
    public let included: [U]?
    
    public init(data: T, included: [U]? = nil) {
        self.data = data
        self.included = included
    }
}

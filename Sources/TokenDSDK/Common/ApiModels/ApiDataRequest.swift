import Foundation

public struct ApiDataRequest<T: Encodable>: Encodable {
    
    public let data: T
}

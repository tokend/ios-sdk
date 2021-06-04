import Foundation

public struct ApiDataResponse<T: Decodable>: Decodable {
    
    public let data: T
}

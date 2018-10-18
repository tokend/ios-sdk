import Foundation

public struct TFACreateFactorRequest {
    public let url: String
    public let method: RequestMethod
    public let requestData: Data
    public let signedHeaders: RequestHeaders
}

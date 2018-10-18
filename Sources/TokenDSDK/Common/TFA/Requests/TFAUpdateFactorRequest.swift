import Foundation

public struct TFAUpdateFactorRequest {
    public let url: String
    public let method: RequestMethod
    public let requestData: Data
    public let signedHeaders: RequestHeaders
}

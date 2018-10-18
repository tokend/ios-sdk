import Foundation

public struct UpdateWalletRequest {
    public let url: String
    public let method: RequestMethod
    public let parametersEncoding: RequestParametersEncoding
    public let registrationInfoData: Data
    public let signedHeaders: RequestHeaders
}

import Foundation

public struct CreateWalletRequest {
    public let url: String
    public let method: RequestMethod
    public let parametersEncoding: RequestParametersEncoding
    public let registrationInfoData: Data
}

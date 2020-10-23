import Foundation

public extension WalletDataResponse.Attributes {

    @available(*, deprecated, renamed: "login")
    var email: String { login }
}

import Foundation

public extension WalletDataModel {

    @available(*, deprecated, renamed: "login")
    var email: String { return login }
}

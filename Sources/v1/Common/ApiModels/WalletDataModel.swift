import Foundation

public struct WalletDataModel {

    public let login: String
    public let accountId: String
    public let walletId: String
    public let type: String
    public let keychainData: String
    public let walletKDF: WalletKDFParams
    public let verified: Bool
    
    // MARK: -

    public init(
        login: String,
        accountId: String,
        walletId: String,
        type: String,
        keychainData: String,
        walletKDF: WalletKDFParams,
        verified: Bool
        ) {

        self.login = login
        self.accountId = accountId
        self.walletId = walletId
        self.type = type
        self.keychainData = keychainData
        self.walletKDF = walletKDF
        self.verified = verified
    }
}

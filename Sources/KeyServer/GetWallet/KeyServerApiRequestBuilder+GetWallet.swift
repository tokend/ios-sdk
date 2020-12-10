import Foundation

public extension KeyServerApiRequestBuilder {

    /// Builds request to fetch wallet data.
    /// - Parameters:
    ///   - walletId: Wallet id.
    /// - Returns: `GetWalletRequest` model.
    func buildGetWalletRequest(
        walletId: String
        ) -> GetWalletRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/walletsPath/walletId

        let request = GetWalletRequest(
            url: url,
            method: .get
        )

        return request
    }
}

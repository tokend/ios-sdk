import Foundation

public extension KeyServerApiRequestBuilder {

    /// Builds request to post new wallet. Used for update login
    /// - Parameters:
    ///   - walletInfo: Wallet info model.
    /// - Returns: `CreateWalletRequest` model.
    func buildPostWalletV2Request(
        walletId: String,
        walletInfo: WalletInfoModelV2
        ) throws -> PostWalletRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/walletsPath/walletId

        let registrationInfoData = ApiDataRequest<WalletInfoModelV2.WalletInfoData, WalletInfoModelV2.Include>(
            data: walletInfo.data,
            included: walletInfo.included
        )
        let registrationInfoDataEncoded = try registrationInfoData.encode()

        let request = PostWalletRequest(
            url: url,
            method: .post,
            parametersEncoding: .json,
            registrationInfoData: registrationInfoDataEncoded
        )

        return request
    }
}

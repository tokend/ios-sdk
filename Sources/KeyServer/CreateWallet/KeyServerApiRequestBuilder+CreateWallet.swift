import Foundation

public extension KeyServerApiRequestBuilder {

    /// Builds request to fetch wallet KDF params from api.
    /// - Parameters:
    ///   - walletInfo: Wallet info model.
    /// - Returns: `CreateWalletRequest` model.
    func buildCreateWalletV2Request(
        walletInfo: WalletInfoModelV2
        ) throws -> CreateWalletRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/walletsPath

        let registrationInfoData = ApiDataRequest<WalletInfoModelV2.WalletInfoData, WalletInfoModelV2.Include>(
            data: walletInfo.data,
            included: walletInfo.included
        )
        let registrationInfoDataEncoded = try registrationInfoData.encode()

        let request = CreateWalletRequest(
            url: url,
            method: .post,
            parametersEncoding: .json,
            registrationInfoData: registrationInfoDataEncoded
        )

        return request
    }
}

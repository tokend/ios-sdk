import Foundation

public extension KeyServerApiRequestBuilder {

    /// Builds request to fetch wallet data.
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - latitude: User's location latitude.
    ///   - longitude: User's location longitude.
    /// - Returns: `GetWalletRequest` model.
    func buildMUNAGetWalletRequest(
        walletId: String,
        latitude: String,
        longitude: String
        ) -> MUNAGetWalletRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/walletsPath/walletId
            .addParam(key: "location_lat", value: latitude)
            .addParam(key: "location_long", value: longitude)
        
        let request = MUNAGetWalletRequest(
            url: url,
            method: .get
        )
        
        return request
    }
}

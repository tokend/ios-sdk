import Foundation

public extension KeyServerApiRequestBuilder {

    private var kdfPath: String { "kdf" }
    private var emailParameterKey: String { "email" }
    private var isRecoveryParameterKey: String { "is_recovery" }

    /// Builds request to fetch wallet KDF params.
    /// - Parameters:
    ///   - login: Login associated with wallet.
    ///   - isRecovery: Flag to indicate whether is recovery keychain data is requested.
    /// - Returns: `GetWalletKDFRequest` model.
    func buildGetWalletKDFRequest(
        login: String,
        isRecovery: Bool
        ) -> GetWalletKDFRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/walletsPath/kdfPath

        var parameters = RequestParameters()
        parameters[emailParameterKey] = login
        if isRecovery {
            parameters[isRecoveryParameterKey] = true
        }

        let request = GetWalletKDFRequest(
            url: url,
            method: .get,
            parameters: parameters,
            parametersEncoding: .url
        )

        return request
    }
}

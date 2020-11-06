import Foundation

public extension KeyServerApiRequestBuilder {
    
    /// Builds request to fetch KDF params from api.
    /// - Returns: `GetKDFParamsRequest` model.
    func buildGetKDFParamsRequest() -> GetKDFParamsRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath("kdf")

        let request = GetKDFParamsRequest(
            url: url,
            method: .get,
            parametersEncoding: .url
        )

        return request
    }
}

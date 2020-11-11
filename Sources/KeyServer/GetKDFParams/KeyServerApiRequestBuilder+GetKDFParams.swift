import Foundation

public extension KeyServerApiRequestBuilder {

    private var kdfPath: String { "kdf" }
    
    /// Builds request to fetch KDF params from api.
    /// - Returns: `GetKDFParamsRequest` model.
    func buildGetKDFParamsRequest(
    ) -> GetKDFParamsRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/kdfPath

        let request = GetKDFParamsRequest(
            url: url,
            method: .get,
            parametersEncoding: .url
        )

        return request
    }
}

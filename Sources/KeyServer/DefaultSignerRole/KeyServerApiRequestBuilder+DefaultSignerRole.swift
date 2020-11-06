import Foundation

public extension KeyServerApiRequestBuilder {

    private var keyValue: String { "key_value" }
    private var signerRoleDefault: String { "signer_role:default" }

    /// Builds request to fetch default signer role id.
    /// - Returns: `SystemInfoRequest` model.
    func buildDefaultRoleIdRequest() -> DefaultRoleIdRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/self.keyValue/self.signerRoleDefault

        let request = DefaultRoleIdRequest(
            url: url,
            method: .get
        )

        return request
    }
}

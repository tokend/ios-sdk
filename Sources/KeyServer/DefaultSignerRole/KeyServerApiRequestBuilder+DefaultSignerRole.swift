import Foundation

public extension KeyServerApiRequestBuilder {

    private var keyValue: String { "key_value" }
    private var signerRoleDefault: String { "signer_role:default" }

    /// Builds request to fetch default signer role id.
    /// - Returns: `SystemInfoRequest` model.
    func buildDefaultSignerRoleIdRequest(
    ) -> DefaultSignerRoleIdRequest {

        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl/keyValue/signerRoleDefault

        let request = DefaultSignerRoleIdRequest(
            url: url,
            method: .get
        )

        return request
    }
}

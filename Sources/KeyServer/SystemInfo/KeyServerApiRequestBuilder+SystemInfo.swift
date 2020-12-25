import Foundation

public extension KeyServerApiRequestBuilder {

    /// Builds request to fetch system info from api.
    /// - Returns: `SystemInfoRequest` model.
    func buildSystemInfoRequest() -> SystemInfoRequest {
        let baseUrl = self.apiConfiguration.urlString

        let request = SystemInfoRequest(
            url: baseUrl,
            method: .get
        )

        return request
    }
}

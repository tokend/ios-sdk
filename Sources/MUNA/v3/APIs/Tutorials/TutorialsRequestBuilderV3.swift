import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch tutorials data
public class TutorialsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties

    private var integrations: String { "integrations" }
    private var video: String { "video" }
    
    /// Builds request to get videos list
    public func buildListVideosRequest(
        filters: TutorialsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = self.integrations/self.video
        
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            .simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

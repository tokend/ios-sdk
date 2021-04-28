import Foundation

public extension DMS {
    
    class ProjectsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
        
        // MARK: - Private properties
        
        private var integrations: String { "integrations" }
        private var dms: String { "dms" }
        private var projects: String { "projects" }
    }
}

// MARK: - Public methods

public extension DMS.ProjectsRequestBuilderV3 {
    
    func buildGetListOfProjects(
        filters: DMS.ProjectsRequestFiltersV3,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.integrations/self.dms/self.projects
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            .simpleQueryPagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

import Foundation

public extension DMS {
    class ProjectsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
        
        // MARK: - Private properties
        
        private var projects: String { "projects" }
    }
}

// MARK: - Public methods

public extension DMS.ProjectsRequestBuilderV3 {
    
    func buildGetListOfProjects(
        filters: ProjectsRequestFiltersV3,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.projects
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            .simpleQuery(
                path: path,
                method: .get,
                queryParameters: queryParameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}

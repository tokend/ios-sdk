import Foundation

public extension DMS {
    
    enum ProjectsRequestFilterOptionV3: FilterOption {
        
        /// IDs of projects
        case id(_ value: [String])
        case name(_ value: String)
        case shortName(_ value: String)
        case address(_ value: String)
        case country(_ value: String)
    }
    
    class ProjectsRequestFiltersV3: RequestFilters<ProjectsRequestFilterOptionV3> {}
}

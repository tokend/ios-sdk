import Foundation

public enum ProjectsRequestFilterOptionV3: FilterOption {
    
    case id(_ value: [String])
    case name(_ value: String)
    case shortName(_ value: String)
    case address(_ value: String)
    case country(_ value: String)
}

public class ProjectsRequestFiltersV3: RequestFilters<ProjectsRequestFilterOptionV3> {}
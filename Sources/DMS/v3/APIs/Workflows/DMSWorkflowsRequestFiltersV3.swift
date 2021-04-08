import Foundation

public extension DMS {
    
    enum WorkflowsRequestFilterOptionV3: FilterOption {
        
        case projectId(_ value: Int)
        case userId(_ value: String)
        case documentNo(_ value: String)
        case documentTitle(_ value: String)
    }
    
    class WorkflowsRequestFiltersV3: RequestFilters<WorkflowsRequestFilterOptionV3> {}
}

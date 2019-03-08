import Foundation

public enum ChangeRoleRequestsFilterOptionV3: FilterOption {
    
    /// Filters requests by requestor - source of the operation.
    case requestor(String)
    
    /// Filters requests by reviewer - account assigned to review requests.
    case reviewer(String)
    
    /// Other filters.
    case other(_ value: [String: String])
}

public class ChangeRoleRequestsFiltersV3: RequestFilters<ChangeRoleRequestsFilterOptionV3> {}

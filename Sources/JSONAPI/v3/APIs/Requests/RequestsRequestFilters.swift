import Foundation

public enum RequestsRequestFilterOptionV3: FilterOption {
    
    case requestor(_ accountId: String)     // If present, the result will return only requests for specified requestor.
    case reviewer(_ accountId: String)     // If present, the result will return only requests for specified reviewer.
    case state(_ state: Int)     // If present, the result will return only requests for specified state.
    case type(_ type: Int)     // If present, the result will return only requests for specified type.
}

public class RequestsFiltersV3: RequestFilters<RequestsRequestFilterOptionV3> {}

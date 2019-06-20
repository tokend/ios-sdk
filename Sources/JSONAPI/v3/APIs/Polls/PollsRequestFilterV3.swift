import Foundation

public enum PollsRequestFilterOptionV3: FilterOption {

    // Filters polls by specified owner id
    case owner(_ ownerAccountId: String)

    // Filters polls by a specified poll state
    case state(_ value: Int)

    // Other filters.
    case other(_ value: [String: String])
}

public class PollsRequestFiltersV3: RequestFilters<PollsRequestFilterOptionV3> {}

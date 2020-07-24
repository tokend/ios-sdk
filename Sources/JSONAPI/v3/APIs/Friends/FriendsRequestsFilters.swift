import Foundation

public enum FriendsRequestsFilterOption: FilterOption {

    /// UTC timestamp.
    case after(TimeInterval)
}

public class FriendsRequestsFilters: RequestFilters<FriendsRequestsFilterOption> {}

import Foundation

public enum CardsRequestsFilterOption: FilterOption {

    /// Filter cards by owner account. If provided - card owner account's signature must be added to the request.
    case owner(String)

    /// Filter cards by their state.
    case state(String)
}

public class CardsRequestsFilters: RequestFilters<CardsRequestsFilterOption> {}

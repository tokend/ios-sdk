import Foundation

public enum InvitationsRequestFilterOptionV3: FilterOption {

    case states(_ value: [Int32])
    case host(_ value: String)
    case guest(_ value: String)
    case place(_ value: String)
}

public class InvitationsRequestFiltersV3: RequestFilters<InvitationsRequestFilterOptionV3> {}

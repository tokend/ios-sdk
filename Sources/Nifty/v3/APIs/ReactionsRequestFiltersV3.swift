import Foundation

public enum ReactionsRequestFilterOptionV3: FilterOption {

    case reactionType(String)
}

public class ReactionsRequestFiltersV3: RequestFilters<ReactionsRequestFilterOptionV3> {}

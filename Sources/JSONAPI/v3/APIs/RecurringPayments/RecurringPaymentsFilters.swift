import Foundation

public enum RecurringPaymentsRequestsFilterOption: FilterOption {

    /// Filter schedules by destination balance.
    /// If provided - destination account's (owner of the provided balance) signature must be added to the request.
    case destinationBalance(String)

    /// Filter schedules by destination account.
    /// If provided - destination account's signature must be added to the request.
    case destinationAccount(String)

    /// Filter schedules by source account. If provided - source account's signature must be added to the request.
    case sourceAccount(String)

    /// Filter schedules by source balance.
    /// If provided - source account's (owner of the provided balance) signature must be added to the request.
    case sourceBalance(String)
}

public class RecurringPaymentsRequestsFilters: RequestFilters<RecurringPaymentsRequestsFilterOption> {}

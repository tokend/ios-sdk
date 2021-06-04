import Foundation

@available(*, deprecated)
public protocol AmountFormatterProtocol {
    func stringFrom(_ decimal: Decimal?) -> String?
    func decimalFrom(_ string: String?) -> Decimal?
}

@available(*, deprecated)
public enum AmountFormatters {
    
    static public private(set) var sunQueryFormatter: AmountFormatterProtocol = {
        return SunQueryAmountFormatter()
    }()
}

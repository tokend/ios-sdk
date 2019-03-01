import Foundation

public protocol AmountFormatterProtocol {
    func stringFrom(_ decimal: Decimal?) -> String?
    func decimalFrom(_ string: String?) -> Decimal?
}

public enum AmountFormatters {
    
    static public private(set) var sunQueryFormatter: AmountFormatterProtocol = {
        return SunQueryAmountFormatter()
    }()
}

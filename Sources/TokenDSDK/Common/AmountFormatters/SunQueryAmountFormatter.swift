import Foundation

/// Class provides functionality that allows to format amount
public class SunQueryAmountFormatter: AmountFormatterProtocol {
    
    public static let maximumFractionDigits: Int = 6
    
    let numberFormatter: NumberFormatter
    
    public init() {
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.minimumFractionDigits = 0
        self.numberFormatter.usesGroupingSeparator = false
        self.numberFormatter.decimalSeparator = "."
        self.numberFormatter.maximumFractionDigits = SunQueryAmountFormatter.maximumFractionDigits
    }
    
    // MARK: - AmountFormatterProtocol
    
    /// Method formats `Decimal` value to `String`
    /// - Parameters:
    ///     - decimal: Value to be formatted
    /// - Returns: `String?`
    public func stringFrom(_ decimal: Decimal?) -> String? {
        guard let decimal = decimal else {
            return nil
        }
        
        return self.numberFormatter.string(from: NSDecimalNumber(decimal: decimal))
    }
    
    /// Method formats `String` value to `Decimal`
    /// - Parameters:
    ///     - string: Value to be formatted
    /// - Returns: `Decimal?`
    public func decimalFrom(_ string: String?) -> Decimal? {
        guard let string = string else {
            return nil
        }
        
        return self.numberFormatter.number(from: string)?.decimalValue
    }
}

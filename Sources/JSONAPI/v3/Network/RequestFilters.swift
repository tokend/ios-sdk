import Foundation

public protocol FilterOption {
    
    func getFilterItems() -> [String: String]
}

public class RequestFilters<FO: FilterOption> {
    
    // MARK: - Public properties
    
    public private(set) var filterItems: [String: String] = [:]
    
    // MARK: -
    
    public required init() {}
    
    public static func empty() -> Self {
        return self.init()
    }
    
    // MARK: - Public
    
    /// Creates instance and adds filter option.
    public static func with(_ filterOption: FO) -> Self {
        return self.init().addFilter(filterOption)
    }
    
    /// Adds filter option.
    @discardableResult
    public func addFilter(_ filterOption: FO) -> Self {
        return self.addFilterItems(filterOption.getFilterItems())
    }
    
    /// Adds filter items.
    @discardableResult
    public func addFilterItems(
        _ filterItems: [String: String],
        mergeInUnique: Bool = true
        ) -> Self {
        
        return self.addFilterItems(filterItems.map({ $0 }), mergeInUnique: mergeInUnique)
    }
    
    /// Adds filter items sequence.
    @discardableResult
    public func addFilterItems(
        _ filterItemsSequence: [(key: String, value: String)],
        mergeInUnique: Bool = true
        ) -> Self {
        
        if mergeInUnique {
            self.filterItems.mergeInUnique(filterItemsSequence)
        } else {
            self.filterItems.merge(filterItemsSequence, uniquingKeysWith: { (_, key2) in
                return key2
            })
        }
        
        return self
    }
    
    // Sets filter options.
    @discardableResult
    public func set(_ filterOptions: [FO]) -> Self {
        self.filterItems = [:]
        filterOptions.forEach { (fo) in
            self.addFilter(fo)
        }
        
        return self
    }
    
    // Sets filter items.
    @discardableResult
    public func set(_ filterItems: [String: String]) -> Self {
        self.filterItems = filterItems
        
        return self
    }
}

extension FilterOption {
    
    public func getFilterItems() -> [String: String] {
        let selfMirror = Mirror(reflecting: self)
        return selfMirror.getEnumCaseFilterItems()
    }
}

extension Mirror {
    
    public func getEnumCaseFilterItems() -> [String: String] {
        guard let displayStyle = self.displayStyle, displayStyle == .enum else {
            return [:]
        }
        
        let child = self.children.first
        
        guard let key = child?.label, let value = child?.value else {
            return [:]
        }
        
        let filterValue: String
        switch value {
            
        case let dateValue as Date:
            filterValue = DateFormatters.rfc3339DateFormatter.string(from: dateValue)
            
        case let boolValue as Bool:
            filterValue = boolValue ? "1" : "0"

        case let int32Array as [Int32]:
            filterValue = int32Array.map { "\($0)" }.joined(separator: ",")
            
        case let stringValue as CustomStringConvertible:
            filterValue = "\(stringValue)"
            
        case let dictionaryValue as [String: String]:
            return dictionaryValue
            
        default:
            #if DEBUG
            fatalError("Unrecognized filter value: \(value)")
            #else
            return [:]
            #endif
        }
        
        return [key: filterValue]
    }
}

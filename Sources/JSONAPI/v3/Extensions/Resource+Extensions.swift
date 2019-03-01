import Foundation
import DLJSONAPI

extension Resource {
    
    // MARK: String
    
    public func stringOptionalValue(
        key: CodingKey
        ) -> String? {
        
        return self.value(forKey: key) as? String
    }
    
    public func setStringOptionalValue(
        _ value: String?,
        key: CodingKey
        ) {
        
        self.setValue(value, forKey: key)
    }
    
    // MARK: Decimal
    
    public func decimalOptionalValue(
        key: CodingKey
        ) -> Decimal? {
        
        if let string = self.value(forKey: key) as? String,
            let value = Decimal(string: string) {
            return value
        } else {
            return nil
        }
    }
    
    public func setDecimalOptionalValue(
        _ value: Decimal?,
        key: CodingKey
        ) {
        
        if let value = value {
            let string = "\(value)"
            self.setValue(string, forKey: key)
        } else {
            self.setValue(nil, forKey: key)
        }
    }
    
    // MARK: Int
    
    public func intOptionalValue(
        key: CodingKey
        ) -> Int? {
        
        return self.value(forKey: key) as? Int
    }
    
    public func setIntOptionalValue(
        _ value: Int?,
        key: CodingKey
        ) {
        
        self.setValue(value, forKey: key)
    }
    
    // MARK: Int32
    
    public func int32OptionalValue(
        key: CodingKey
        ) -> Int32? {
        
        return self.value(forKey: key) as? Int32
    }
    
    public func setInt32OptionalValue(
        _ value: Int32?,
        key: CodingKey
        ) {
        
        self.setValue(value, forKey: key)
    }
    
    // MARK: Int64
    
    public func int64OptionalValue(
        key: CodingKey
        ) -> Int64? {
        
        return self.value(forKey: key) as? Int64
    }
    
    public func setInt64OptionalValue(
        _ value: Int64?,
        key: CodingKey
        ) {
        
        self.setValue(value, forKey: key)
    }
    
    // MARK: UInt32
    
    public func uint32OptionalValue(
        key: CodingKey
        ) -> UInt32? {
        
        return self.value(forKey: key) as? UInt32
    }
    
    public func setUInt32OptionalValue(
        _ value: UInt32?,
        key: CodingKey
        ) {
        
        self.setValue(value, forKey: key)
    }
    
    // MARK: UInt64
    
    public func uint64OptionalValue(
        key: CodingKey
        ) -> UInt64? {
        
        return self.value(forKey: key) as? UInt64
    }
    
    public func setUInt64OptionalValue(
        _ value: UInt64?,
        key: CodingKey
        ) {
        
        self.setValue(value, forKey: key)
    }
    
    // MARK: Bool
    
    public func boolOptionalValue(
        key: CodingKey
        ) -> Bool? {
        
        return self.value(forKey: key) as? Bool
    }
    
    public func setBoolOptionalValue(
        _ value: Bool?,
        key: CodingKey
        ) {
        
        if let value = value {
            let number = value as NSNumber
            self.setValue(number, forKey: key)
        } else {
            self.setValue(nil, forKey: key)
        }
    }
    
    // MARK: Date
    
    public func dateOptionalValue(
        key: CodingKey,
        dateFormatter: DateFormatter = DateFormatters.iso8601DateFormatter
        ) -> Date? {
        
        guard let dateString = self.value(forKey: key) as? String else {
            return nil
        }
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        return date
    }
    
    public func setDateOptionalValue(
        _ value: Date?,
        key: CodingKey,
        dateFormatter: DateFormatter = DateFormatters.iso8601DateFormatter
        ) {
        
        guard let value = value else {
            self.setValue(nil, forKey: key)
            return
        }
        
        let dateString = dateFormatter.string(from: value)
        
        self.setValue(dateString, forKey: key)
    }
    
    // MARK: Dictionary
    
    public func dictionaryOptionalValue(
        key: CodingKey
        ) -> [String: Any]? {
        
        return self.value(forKey: key) as? [String: Any]
    }
    
    public func setDictionaryOptionalValue(
        _ value: [String: Any]?,
        key: CodingKey
        ) {
        
        self.setValue(value, forKey: key)
    }
    
    // MARK: Relation Single
    
    public func relationSingleOptionalValue<T: Resource>(
        key: CodingKey
        ) -> T? {
        
        return self.value(forKey: key) as? T
    }
    
    public func setRelationSingleOptionalValue(
        _ single: Resource?,
        key: CodingKey
        ) {
        
        self.setValue(single, forKey: key)
    }
    
    // MARK: Relation Collection
    
    public func relationCollectionOptionalValue<T: Resource>(
        key: CodingKey
        ) -> [T]? {
        
        return self.value(forKey: key) as? [T]
    }
    
    public func setRelationCollectionOptionalValue(
        _ collection: [Resource]?,
        key: CodingKey
        ) {
        
        self.setValue(collection, forKey: key)
    }
    
    // MARK: Decodable
    
    public func codableOptionalValue<T: Decodable> (
        key: CodingKey
        ) -> T? {
        
        guard let codableDictionary = self.value(forKey: key) else {
            return nil
        }
        
        guard let encodedData = try? JSONSerialization.data(withJSONObject: codableDictionary, options: []) else {
            return nil
        }
        
        let decoded = try? JSONDecoder().decode(T.self, from: encodedData)
        
        return decoded
    }
    
    public func setCodableOptionalValue<T: Encodable> (
        _ value: T?,
        key: CodingKey
        ) {
        
        var encoded: Any?
        
        if let value = value, let encodedData = try? JSONEncoder().encode(value) {
            encoded = try? JSONSerialization.jsonObject(with: encodedData, options: [.mutableContainers])
        }
        
        self.setValue(encoded, forKey: key)
    }
    
    // MARK: -
    
    public func value(forKey key: CodingKey) -> Any? {
        return self.value(forKey: key.stringValue)
    }
    
    public func setValue(_ value: Any?, forKey key: CodingKey) {
        self.setValue(value, forKey: key.stringValue)
    }
}

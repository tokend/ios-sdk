import Foundation

extension KeyedDecodingContainer {
    
    public func decodeString(
        key: KeyedDecodingContainer.Key
        ) throws -> String {
        
        return try self.decode(String.self, forKey: key)
    }
    
    public func decodeOptionalString(
        key: KeyedDecodingContainer.Key
        ) -> String? {
        
        return try? self.decode(String.self, forKey: key)
    }
    
    public func decodeDecimalString(
        key: KeyedDecodingContainer.Key
        ) throws -> Decimal {
        
        let string = try self.decode(String.self, forKey: key)
        guard let value = Decimal(string: string) else {
            let context = DecodingError.Context(
                codingPath: [key],
                debugDescription: "Failed to convert String to Decimal for key \(key): \(string)"
            )
            throw DecodingError.typeMismatch(Decimal.self, context)
        }
        
        return value
    }
    
    public func decodeOptionalDecimalString(
        key: KeyedDecodingContainer.Key
        ) -> Decimal? {
        
        if let string = try? self.decode(String.self, forKey: key),
            let value = Decimal(string: string) {
            return value
        } else {
            return nil
        }
    }
    
    public func decodeOptionalBool(
        key: KeyedDecodingContainer.Key
        ) -> Bool? {
        
        return try? self.decode(Bool.self, forKey: key)
    }
    
    public func decodeDateString(
        key: KeyedDecodingContainer.Key,
        dateFormatter: DateFormatter = DateFormatters.iso8601DateFormatter
        ) throws -> Date {
        
        let dateString = try self.decode(String.self, forKey: key)
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Cannot parse date for key \(key): \(dateString)"
            )
        }
        return date
    }
    
    public func decodeOptionalDateString(
        key: KeyedDecodingContainer.Key,
        dateFormatter: DateFormatter = DateFormatters.iso8601DateFormatter
        ) -> Date? {
        
        if let string = try? self.decode(String.self, forKey: key),
            let value = dateFormatter.date(from: string) {
            return value
        } else {
            return nil
        }
    }
    
    public func decodeOptionalObject<T: Decodable>(
        _ object: T.Type,
        key: KeyedDecodingContainer.Key
        ) -> T? {
        
        if let value = try? self.decode(object, forKey: key) {
            return value
        } else {
            return nil
        }
    }
}

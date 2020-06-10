import Foundation

/// JSON decoders collection.
public enum JSONCoders {
    
    /// Snakecase JSON encoder
    public static let snakeCaseEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    /// Snakecase JSON decoder
    public static let snakeCaseDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    /// Camelcase JSON decoder
    public static let camelCaseDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()
}

public extension Decodable {
    
    /// Method decodes from json data of `Data` type to `Decodable`
    /// - Parameters:
    ///   - from: Source data to be decoded
    ///   - decoder: Object that decodes data from `Data` to `Decodable`
    /// - Returns: `Decodable`
    public static func decode(from jsonData: Data, decoder: JSONDecoder? = nil) throws -> Self {
        return try (decoder ?? JSONCoders.snakeCaseDecoder).decode(Self.self, from: jsonData)
    }
    
    /// Method decodes from json of `JSON` type to `Decodable`
    /// - Parameters:
    ///   - from: Source data to be decoded
    ///   - decoder: Object that decodes data from `JSON` to `Decodable`
    /// - Returns: `Decodable`
    public static func decode(from json: JSON, decoder: JSONDecoder? = nil) throws -> Self {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try self.decode(from: jsonData, decoder: decoder)
    }
}

public extension Encodable {
    
    /// Encodes this value into the given encoder.
    ///
    ///This method throws an error if any values are invalid for the given
    /// encoder's format.
    /// - Returns: `Data`
    public func encode() throws -> Data {
        return try JSONCoders.snakeCaseEncoder.encode(self)
    }

    enum DictionaryEncodingError: Error {
        case cannotCast
    }

    public func documentDictionary() throws -> [String: Any] {
        let encodedRequest = try encode(),
        let object = try JSONSerialization.jsonObject(with: encodedRequest, options: []),

        guard let dictionary = object as? [String: Any] else {
            throw DictionaryEncodingError.cannotCast
        }
        return dictionary
    }
}

public struct JSONCodingKeys: CodingKey {
    
    public var stringValue: String
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    public var intValue: Int?
    
    public init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer {
    
    public func decodeDictionary(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decodeDict(type)
    }
    
    public func decodeDictionaryIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try self.decodeDictionary(type, forKey: key)
    }
    
    public func decodeArray(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
    
    public func decodeArrayIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try self.decodeArray(type, forKey: key)
    }
    
    public func decodeDict(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()
        
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? self.decodeDictionary([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? self.decodeArray([Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    
    public mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first
            // and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? self.decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? self.decode([Any].self) {
                array.append(nestedArray)
            }
        }
        return array
    }
    
    public mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decodeDict(type)
    }
}

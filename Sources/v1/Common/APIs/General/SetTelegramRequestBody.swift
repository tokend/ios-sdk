import Foundation

public struct SetTelegramRequestBody: Encodable {
    public let data: Data
    
    public struct Data: Encodable {
        public let attributes: Attributes
        
        public struct Attributes: Encodable {
            public let username: String
        }
    }
    
    public init(username: String) {
        self.data = Data(attributes: Data.Attributes(username: username))
    }
    
    public func toJSON() -> [String: Any]? {
        guard let jsonData = try? JSONEncoder().encode(self),
            let json = try? JSONSerialization.jsonObject(
                with: jsonData,
                options: .allowFragments
                ) as? [String: Any] else {
                    
                    return nil
        }
        
        return json
    }
}

import Foundation

extension Dictionary where Key == String, Value == String {
    
    public func toQueryItems() -> [URLQueryItem] {
        return self.map({ (key, value) -> URLQueryItem in
            return URLQueryItem(
                name: key,
                value: value
            )
        })
    }
}

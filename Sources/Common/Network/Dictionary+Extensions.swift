import Foundation

extension Dictionary {
    
    public mutating func mergeInUnique<S>(_ other: S) where S: Sequence, S.Element == (Key, Value) {
        self.merge(other, uniquingKeysWith: { (val1, _) -> Value in
            return val1
        })
    }
}

import Foundation

extension Array where Element: Equatable {
    
    public mutating func appendUnique(_ newElement: Element) {
        guard !self.contains(newElement) else {
            return
        }
        
        self.append(newElement)
    }
    
    public mutating func appendUniques<S>(contentsOf newElements: S) where Element == S.Element, S: Sequence {
        for newElement in newElements {
            self.appendUnique(newElement)
        }
    }
}

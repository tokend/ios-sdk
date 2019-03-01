import Foundation

/// Abstract protocol for cancelable object
public protocol Cancelable {
    
    /// Shows whether is current instance is canceled
    var canceled: Bool { get }
    
    /// Canceles current instance
    func cancel()
    
    /// Used to overwright internal reference. Should return `self` on `get`.
    var cancelable: Cancelable? { get set }
}

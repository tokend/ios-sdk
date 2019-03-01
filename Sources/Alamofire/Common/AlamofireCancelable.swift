import Foundation
import Alamofire

/// Pointer to network request with ability to cancel it.
public class AlamofireCancelable: Cancelable {
    
    // MARK: - Public properties
    
    public var request: Request? {
        didSet {
            if self.canceled {
                self.cancelRequest()
            }
        }
    }
    
    public private(set) var canceled: Bool = false {
        didSet {
            if self.canceled {
                self.cancelRequest()
            }
        }
    }
    
    public var cancelable: Cancelable? {
        get { return self }
        set {
            if let alamofireCancelable = newValue as? AlamofireCancelable {
                self.request = alamofireCancelable.request
            }
        }
    }
    
    // MARK: -
    
    public init(
        request: Request?
        ) {
        
        self.request = request
    }
    
    // MARK: - Public
    
    /// Method cancels the execution of current request if it exists
    public func cancel() {
        self.canceled = true
    }
    
    // MARK: - Private
    
    private func cancelRequest() {
        self.request?.cancel()
    }
}

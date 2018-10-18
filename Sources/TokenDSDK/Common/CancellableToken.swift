import Foundation
import Alamofire

/// Pointer to network request with ability to cancel it.
public class CancellableToken {
    
    internal var request: Request?
    
    internal init(
        request: Request?
        ) {
        
        self.request = request
    }
    
    /// Method cancels the execution of current request if it exists
    public func cancel() {
        self.request?.cancel()
    }
}

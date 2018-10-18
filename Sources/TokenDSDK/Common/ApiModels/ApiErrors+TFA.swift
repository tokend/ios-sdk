import Foundation

extension ApiErrors {
    
    /// Method checks if it is necessary to have two factor authentication
    /// to get access to account.
    /// - Parameters:
    ///     - handler: Object that execute TFA initiation
    ///     - initiateTFA: Flag that defines if initiation of TFA is needed
    ///     - onCompletion: Completion block that will be executed after the finish of TFA initiation
    ///     - result: The member of `TFAResult`
    ///     - onNoTFA: Block of code that will be executed if TFA is not required
    public func checkTFARequired(
        handler: TFAHandlerProtocol,
        initiateTFA: Bool,
        onCompletion: @escaping (_ result: TFAResult) -> Void,
        onNoTFA: @escaping () -> Void
        ) {
        
        if let error = self.firstErrorWith(
            status: ApiError.Status.forbidden,
            code: ApiError.Code.tfaRequired
            ), let meta = error.meta {
            
            if initiateTFA {
                handler.initiateTFA(
                    meta: meta,
                    completion: { tfaResult in
                        onCompletion(tfaResult)
                })
            } else {
                onCompletion(.failure(self))
            }
        } else {
            onNoTFA()
        }
    }
}

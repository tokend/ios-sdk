import Foundation
import DLJSONAPI

public class InfoApiV3: JSONAPI.BaseApi {
    
    public let requestBuilder: InfoRequestBuilderV3
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = .init(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
}

// MARK: Public methods

public extension InfoApiV3 {
    
    /// Allows getting basic info about horizon state and it's dependencies
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///     - result: Member of `RequestSingleResult<Horizon.HorizonStateResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    func requestInfo(
        completion: @escaping (_ result: RequestSingleResult<Horizon.HorizonStateResource>) -> Void
    ) -> Cancelable {
        
        let request = self.requestBuilder.buildInfoRequest()
        
        let cancelable = self.requestSingle(
            Horizon.HorizonStateResource.self,
            request: request,
            completion: completion
        )
        
        return cancelable
    }
}

import Foundation

/// Base api request builder stack.
public struct BaseApiRequestBuilderStack {
    
    // MARK: - Public properties
    
    public let apiConfiguration: ApiConfiguration
    public let requestSigner: RequestSignerProtocol
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        requestSigner: RequestSignerProtocol
        ) {
        
        self.apiConfiguration = apiConfiguration
        self.requestSigner = requestSigner
    }
    
    // MARK: - Public
    
    public static func fromApiStack(_ apiStack: BaseApiStack) -> BaseApiRequestBuilderStack {
        return BaseApiRequestBuilderStack(
            apiConfiguration: apiStack.apiConfiguration,
            requestSigner: apiStack.requestSigner
        )
    }
}

/// Parent for other request builder classes.
public class BaseApiRequestBuilder {
    
    public let apiConfiguration: ApiConfiguration
    public let requestSigner: RequestSignerProtocol
    
    public init(builderStack: BaseApiRequestBuilderStack) {
        self.apiConfiguration = builderStack.apiConfiguration
        self.requestSigner = builderStack.requestSigner
    }
    
    /// Method transforms request parameters to dicitionary
    /// - Parameters:
    ///     - parameters: Parameters to be trasformed
    /// - Returns: `RequestParameters`
    public func requestParametersToDictionary<ParametersType: Encodable>(
        _ parameters: ParametersType?
        ) -> RequestParameters? {
        
        guard let parameters = parameters,
            let data = try? JSONCoders.snakeCaseEncoder.encode(parameters),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? RequestParameters
            else {
                return nil
        }
        return dictionary
    }
}

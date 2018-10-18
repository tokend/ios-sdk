import Foundation

/// Base api stack model.
public struct BaseApiStack {
    
    public let apiConfiguration: ApiConfiguration
    public let callbacks: ApiCallbacks
    public let network: Network
    public let requestSigner: RequestSignerProtocol
    public let verifyApi: TFAVerifyApi
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        callbacks: ApiCallbacks,
        network: Network,
        requestSigner: RequestSignerProtocol,
        verifyApi: TFAVerifyApi
        ) {
        
        self.apiConfiguration = apiConfiguration
        self.callbacks = callbacks
        self.network = network
        self.requestSigner = requestSigner
        self.verifyApi = verifyApi
    }
}

/// Parent for other api classes.
public class BaseApi {
    
    public let apiConfiguration: ApiConfiguration
    public let network: Network
    public let requestSigner: RequestSignerProtocol
    public let tfaHandler: TFAHandler
    
    public init(apiStack: BaseApiStack) {
        self.apiConfiguration = apiStack.apiConfiguration
        self.network = apiStack.network
        self.requestSigner = apiStack.requestSigner
        self.tfaHandler = TFAHandler(
            callbacks: apiStack.callbacks,
            verifyApi: apiStack.verifyApi
        )
    }
}

import Foundation

/// Base api stack model.
public struct BaseApiStack {
    
    public let apiConfiguration: ApiConfiguration
    public let callbacks: ApiCallbacks
    public let network: NetworkProtocol
    public let requestSigner: RequestSignerProtocol
    public let verifyApi: TFAVerifyApi
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        callbacks: ApiCallbacks,
        network: NetworkProtocol,
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
    public let network: NetworkFacade
    public let requestSigner: RequestSignerProtocol
    public let tfaHandler: TFAHandler
    
    public required init(apiStack: BaseApiStack) {
        self.apiConfiguration = apiStack.apiConfiguration
        self.network = NetworkFacade(network: apiStack.network)
        self.requestSigner = apiStack.requestSigner
        self.tfaHandler = TFAHandler(
            callbacks: apiStack.callbacks,
            verifyApi: apiStack.verifyApi
        )
    }
}

extension ApiErrors {
    
    public static var failedToDecodeResponse: ApiErrors {
        return ApiErrors(errors: [
            ApiError(
                status: ApiError.Status.responseDecodeFailed,
                code: nil,
                title: ApiError.Title.responseDecodeFailed,
                detail: nil
            )
            ]
        )
    }
}

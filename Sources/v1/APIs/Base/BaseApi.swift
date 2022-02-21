import Foundation

/// Base api stack model.
public struct BaseApiStack {
    
    public var apiConfiguration: ApiConfiguration {
        apiConfigurationProvider.apiConfiguration
    }
    public let apiConfigurationProvider: ApiConfigurationProviderProtocol
    public let callbacks: ApiCallbacks
    public let network: NetworkProtocol
    public let requestSigner: RequestSignerProtocol
    public let verifyApi: TFAVerifyApi
    
    // MARK: -
    
    public init(
        apiConfigurationProvider: ApiConfigurationProviderProtocol,
        callbacks: ApiCallbacks,
        network: NetworkProtocol,
        requestSigner: RequestSignerProtocol,
        verifyApi: TFAVerifyApi
        ) {
        
        self.apiConfigurationProvider = apiConfigurationProvider
        self.callbacks = callbacks
        self.network = network
        self.requestSigner = requestSigner
        self.verifyApi = verifyApi
    }
}

/// Parent for other api classes.
public class BaseApi {
    
    public var apiConfiguration: ApiConfiguration {
        apiConfigurationProvider.apiConfiguration
    }
    public let apiConfigurationProvider: ApiConfigurationProviderProtocol
    public let network: NetworkFacade
    public let requestSigner: RequestSignerProtocol
    public let tfaHandler: TFAHandler
    
    public required init(apiStack: BaseApiStack) {
        self.apiConfigurationProvider = apiStack.apiConfigurationProvider
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

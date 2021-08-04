import Foundation
import DLCryptoKit
import TokenDWallet

/// Allows to send Key Server related requests.
public class KeyServerApi {
    
    // MARK: - Public properties
    
    public var apiConfiguration: ApiConfiguration {
        apiConfigurationProvider.apiConfiguration
    }
    public let apiConfigurationProvider: ApiConfigurationProviderProtocol
    public let requestBuilder: KeyServerApiRequestBuilder
    public let network: NetworkFacade
    public let networkV3: JSONAPI.NetworkFacade
    
    let tfaHandler: TFAHandler
    
    // MARK: -
    
    public init(
        apiConfigurationProvider: ApiConfigurationProviderProtocol,
        callbacks: ApiCallbacks,
        verifyApi: TFAVerifyApi,
        requestSigner: JSONAPI.RequestSignerProtocol,
        network: NetworkProtocol,
        networkV3: JSONAPI.NetworkProtocol
        ) {
        
        self.apiConfigurationProvider = apiConfigurationProvider
        self.requestBuilder = KeyServerApiRequestBuilder(
            apiConfigurationProvider: apiConfigurationProvider,
            network: networkV3
        )
        self.tfaHandler = TFAHandler(
            callbacks: callbacks,
            verifyApi: verifyApi
        )
        self.network = NetworkFacade(network: network)
        self.networkV3 = JSONAPI.NetworkFacade(network: networkV3)
    }
}

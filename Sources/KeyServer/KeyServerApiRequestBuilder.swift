import Foundation

/// Class provides functionality that allows to build requests
/// which are used to communicate with Key Server.
public class KeyServerApiRequestBuilder {
    
    // MARK: - Public properties
    
    public var apiConfiguration: ApiConfiguration {
        apiConfigurationProvider.apiConfiguration
    }
    public let apiConfigurationProvider: ApiConfigurationProviderProtocol
    public let network: JSONAPI.NetworkProtocol

    // MARK: - Internal properties

    internal var walletsPath: String { "wallets" }
    
    // MARK: -
    
    public init(
        apiConfigurationProvider: ApiConfigurationProviderProtocol,
        network: JSONAPI.NetworkProtocol
        ) {
        
        self.apiConfigurationProvider = apiConfigurationProvider
        self.network = network
    }
}

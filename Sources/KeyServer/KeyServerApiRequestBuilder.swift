import Foundation

/// Class provides functionality that allows to build requests
/// which are used to communicate with Key Server.
public class KeyServerApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let apiConfiguration: ApiConfiguration
    public let network: JSONAPI.NetworkProtocol

    // MARK: - Internal properties

    internal var walletsPath: String { "wallets" }
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        network: JSONAPI.NetworkProtocol
        ) {
        
        self.apiConfiguration = apiConfiguration
        self.network = network
    }
}

import Foundation

/// Class provides an access to APIs that are created in lazy manner.
public class API {
    
    private let requestSigner: RequestSignerProtocol
    
    // MARK: - Public properties
    
    public let configuration: ApiConfiguration
    public let callbacks: ApiCallbacks
    public let network: NetworkProtocol
    
    public private(set) lazy var baseApiStack: BaseApiStack = {
        return BaseApiStack(
            apiConfiguration: self.configuration,
            callbacks: self.callbacks,
            network: self.network,
            requestSigner: self.requestSigner,
            verifyApi: self.tfaVerifyApi
        )
    }()
    
    public private(set) lazy var documentsApi: DocumentsApi       = { return self.create() }()
    public private(set) lazy var identitiesApi: IdentitiesApi     = { return self.create() }()
    public private(set) lazy var blobsApi: BlobsApi               = { return self.create() }()
    public private(set) lazy var chartsApi: ChartsApi             = { return self.create() }()
    public private(set) lazy var tfaApi: TFAApi                   = { return self.createTFAApi() }()
    public private(set) lazy var tfaVerifyApi: TFAVerifyApi       = { return self.createTFAVerifyApi() }()
    
    // MARK: -
    
    public init(
        configuration: ApiConfiguration,
        callbacks: ApiCallbacks,
        network: NetworkProtocol,
        requestSigner: RequestSignerProtocol
        ) {
        
        self.configuration = configuration
        self.callbacks = callbacks
        self.network = network
        self.requestSigner = requestSigner
    }
    
    // MARK: - Private

    private func create<ApiType: BaseApi>() -> ApiType {
        let api = ApiType.init(apiStack: self.baseApiStack)
        return api
    }
    
    private func createTFAApi() -> TFAApi {
        let api = TFAApi(
            apiConfiguration: self.baseApiStack.apiConfiguration,
            requestSigner: self.baseApiStack.requestSigner,
            callbacks: self.baseApiStack.callbacks,
            network: self.network
        )
        return api
    }
    
    private func createTFAVerifyApi() -> TFAVerifyApi {
        let api = TFAVerifyApi(
            apiConfiguration: self.configuration,
            requestSigner: self.requestSigner,
            network: self.network
        )
        return api
    }
}
